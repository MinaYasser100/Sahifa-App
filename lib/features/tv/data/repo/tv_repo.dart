import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/tv_videos_model/tv_videos_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/features/tv/data/cache/tv_cache_manager.dart';
import 'package:sahifa/features/tv/data/cache/tv_etag_handler.dart';

abstract class TVRepo {
  Future<Either<String, TvVideosModel>> fetchVideos({
    required String language,
    required int pageNumber,
  });
}

class TVRepoImpl implements TVRepo {
  // Singleton Pattern
  static final TVRepoImpl _instance = TVRepoImpl._internal(DioHelper());
  factory TVRepoImpl() => _instance;

  TVRepoImpl._internal(this._dioHelper) {
    _cacheManager = TVCacheManager();
    _etagHandler = TVETagHandler();
  }

  final DioHelper _dioHelper;
  late final TVCacheManager _cacheManager;
  late final TVETagHandler _etagHandler;

  // Public getters for Cubit
  bool hasValidMemoryCache(int pageNumber) =>
      _cacheManager.hasValidMemoryCache(pageNumber);

  @override
  Future<Either<String, TvVideosModel>> fetchVideos({
    required String language,
    required int pageNumber,
  }) async {
    try {
      // STEP 1: Handle language change
      if (_cacheManager.hasLanguageChanged(language)) {
        _cacheManager.clearAll();
      }
      _cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache (30 min) - Return immediately without network
      if (_cacheManager.hasValidMemoryCache(pageNumber)) {
        log(
          '💾 Using valid memory cache for page $pageNumber (no network request)',
        );
        return _buildSuccessResponse(pageNumber);
      }

      // STEP 3: Memory cache expired - Need to revalidate
      log(
        '📡 Memory cache expired or missing for page $pageNumber - Making network request',
      );

      // STEP 4: Make network request with ETag if available
      final response = await _makeRequest(language, pageNumber);

      _etagHandler.logResponseStatus(response, pageNumber);

      // STEP 5: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(pageNumber);
      }

      // STEP 6: Handle 200 OK with new data
      return _handle200Response(response, pageNumber);
    } catch (e) {
      return _handleError(e, pageNumber);
    }
  }

  /// Build success response from cached data
  Either<String, TvVideosModel> _buildSuccessResponse(int pageNumber) {
    return Right(
      TvVideosModel(
        videos: _cacheManager.getCachedVideos(pageNumber),
        pageNumber: pageNumber,
        totalPages: _cacheManager.getTotalPages(pageNumber),
      ),
    );
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(String language, int pageNumber) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = _cacheManager.getETag(pageNumber);
    final headers = _etagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.videos.path,
      query: {
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: pageNumber,
        ApiQueryParams.language: backendLanguage,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, TvVideosModel> _handle304Response(int pageNumber) {
    log(
      '✅ 304 Not Modified - Data unchanged, using cached data for page $pageNumber',
    );

    if (!_cacheManager.hasCachedData(pageNumber)) {
      log(
        '⚠️ Warning: 304 received but no cached data found for page $pageNumber',
      );
      return Left("cached_data_missing".tr());
    }

    // Update timestamp to extend cache validity
    _cacheManager.updateTimestamp(pageNumber);

    return _buildSuccessResponse(pageNumber);
  }

  /// Handle 200 OK response with new data
  Either<String, TvVideosModel> _handle200Response(
    Response response,
    int pageNumber,
  ) {
    log('📦 200 OK - Received new data for page $pageNumber');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, pageNumber);

    // Parse response
    final tvVideosModel = TvVideosModel.fromJson(response.data);
    final videos = tvVideosModel.videos ?? [];

    // Cache data
    _cacheManager.cachePageData(
      pageNumber: pageNumber,
      videos: videos,
      etag: etag,
      totalPages: tvVideosModel.totalPages,
    );

    return Right(tvVideosModel);
  }

  /// Handle errors with fallback to stale cache
  Either<String, TvVideosModel> _handleError(dynamic error, int pageNumber) {
    // Fallback: Use stale cached data if available
    if (_cacheManager.hasCachedData(pageNumber)) {
      log('⚠️ Network error - Using stale cached data for page $pageNumber');
      return _buildSuccessResponse(pageNumber);
    }

    return Left("failed_to_load_videos".tr());
  }

  /// Force refresh - invalidates cache to trigger revalidation
  Future<Either<String, TvVideosModel>> forceRefresh({
    required String language,
  }) async {
    log('🔄 Force refresh requested - Invalidating cache timestamps');
    _cacheManager.invalidateTimestamps();
    return fetchVideos(language: language, pageNumber: 1);
  }

  /// Clear all cache including ETags (for logout, language change, etc.)
  void clearAllCache() {
    _cacheManager.clearAll();
  }
}
