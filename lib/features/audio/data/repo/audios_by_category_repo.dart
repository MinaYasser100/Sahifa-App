import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_cache_manager.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/model/audios_model/audios_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class AudiosByCategoryRepo {
  Future<Either<String, AudiosModel>> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
    int page = 1,
    int pageSize = 30,
  });
  bool hasValidCache(String categorySlug, int page);
  void clearCache(String categorySlug);
  void clearAllCache();
}

class AudiosByCategoryRepoImpl implements AudiosByCategoryRepo {
  // Singleton Pattern
  static final AudiosByCategoryRepoImpl _instance =
      AudiosByCategoryRepoImpl._internal();
  factory AudiosByCategoryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  AudiosByCategoryRepoImpl._internal() {
    _etagHandler = GenericETagHandler(handlerIdentifier: 'AudiosByCategory');
  }

  late DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Separate cache manager for each category
  final Map<String, GenericCacheManager<AudioItemModel>> _cacheManagers = {};

  // Get or create cache manager for a category
  GenericCacheManager<AudioItemModel> _getCacheManager(String categorySlug) {
    if (!_cacheManagers.containsKey(categorySlug)) {
      _cacheManagers[categorySlug] = GenericCacheManager<AudioItemModel>(
        cacheIdentifier: 'AudiosByCategory_$categorySlug',
      );
    }
    return _cacheManagers[categorySlug]!;
  }

  @override
  bool hasValidCache(String categorySlug, int page) {
    final cacheManager = _getCacheManager(categorySlug);
    return cacheManager.hasValidMemoryCache(page);
  }

  @override
  Future<Either<String, AudiosModel>> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      final cacheManager = _getCacheManager(categorySlug);

      // STEP 1: Handle language change
      if (cacheManager.hasLanguageChanged(language)) {
        cacheManager.clearAll();
      }
      cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache (30 min) - Return immediately without network
      if (cacheManager.hasValidMemoryCache(page)) {
        log('💾 Using valid memory cache for $categorySlug page $page');
        return _buildSuccessResponse(cacheManager, page);
      }

      // STEP 3: Memory cache expired - Need to revalidate
      log(
        '📡 Memory cache expired for $categorySlug page $page - Making network request',
      );

      // STEP 4: Make network request with ETag if available
      final response = await _makeRequest(
        categorySlug,
        language,
        page,
        pageSize,
        cacheManager,
      );

      _etagHandler.logResponseStatus(response, page);

      // STEP 5: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(cacheManager, page);
      }

      // STEP 6: Handle 200 OK with new data
      return _handle200Response(response, cacheManager, page);
    } catch (e) {
      return Left("Error fetching audios".tr());
    }
  }

  /// Build success response from cached data
  Either<String, AudiosModel> _buildSuccessResponse(
    GenericCacheManager<AudioItemModel> cacheManager,
    int page,
  ) {
    return Right(
      AudiosModel(
        audios: cacheManager.getCachedData(page),
        totalPages: cacheManager.getTotalPages(page),
      ),
    );
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(
    String categorySlug,
    String language,
    int page,
    int pageSize,
    GenericCacheManager<AudioItemModel> cacheManager,
  ) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = cacheManager.getETag(page);
    final headers = _etagHandler.prepareHeaders(etag, page);

    return await _dioHelper.getData(
      url: ApiEndpoints.audiosByCategory.path,
      query: {
        ApiQueryParams.categorySlug: categorySlug,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.pageNumber: page,
        ApiQueryParams.pageSize: pageSize,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, AudiosModel> _handle304Response(
    GenericCacheManager<AudioItemModel> cacheManager,
    int page,
  ) {
    log(
      '✅ 304 Not Modified - Data unchanged, using cached data for page $page',
    );

    if (!cacheManager.hasCachedData(page)) {
      log('⚠️ Warning: 304 received but no cached data found for page $page');
      return Left("cached_data_missing".tr());
    }

    // Update timestamp to extend cache validity
    cacheManager.updateTimestamp(page);

    return _buildSuccessResponse(cacheManager, page);
  }

  /// Handle 200 OK response with new data
  Either<String, AudiosModel> _handle200Response(
    Response response,
    GenericCacheManager<AudioItemModel> cacheManager,
    int page,
  ) {
    log('📦 200 OK - Received new data for page $page');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, page);

    // Parse response
    final audiosModel = AudiosModel.fromJson(response.data);
    final audios = audiosModel.audios ?? [];

    // Cache data
    cacheManager.cachePageData(
      pageNumber: page,
      data: audios,
      etag: etag,
      totalPages: audiosModel.totalPages,
    );

    return Right(audiosModel);
  }

  // Force refresh - clears cache for specific category
  Future<Either<String, AudiosModel>> forceRefresh({
    required String categorySlug,
    required String language,
    int page = 1,
    int pageSize = 30,
  }) async {
    clearCache(categorySlug);
    return await fetchAudiosByCategory(
      categorySlug: categorySlug,
      language: language,
      page: page,
      pageSize: pageSize,
    );
  }

  // Clear cache for specific category
  @override
  void clearCache(String categorySlug) {
    final cacheManager = _getCacheManager(categorySlug);
    cacheManager.clearAll();
  }

  // Clear all cache
  @override
  void clearAllCache() {
    for (final manager in _cacheManagers.values) {
      manager.clearAll();
    }
    _cacheManagers.clear();
  }
}
