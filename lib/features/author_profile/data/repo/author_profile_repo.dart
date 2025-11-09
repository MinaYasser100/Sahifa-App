import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_cache_manager.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class AuthorProfileRepo {
  Future<Either<String, ArticlesCategoryModel>> fetchAuthorProfile({
    required String authorName,
    required String language,
    required int pageNumber,
  });
}

class AuthorProfileRepoImpl implements AuthorProfileRepo {
  // Singleton Pattern
  static final AuthorProfileRepoImpl _instance =
      AuthorProfileRepoImpl._internal(DioHelper());
  factory AuthorProfileRepoImpl() => _instance;

  AuthorProfileRepoImpl._internal(this._dioHelper) {
    _cacheManager = GenericCacheManager<ArticleModel>(
      cacheIdentifier: 'AuthorProfile',
    );
    _etagHandler = GenericETagHandler(handlerIdentifier: 'AuthorProfile');
  }

  final DioHelper _dioHelper;
  late final GenericCacheManager<ArticleModel> _cacheManager;
  late final GenericETagHandler _etagHandler;

  // Store current author name for cache isolation
  String? _currentAuthorName;

  // Public getters for Cubit
  bool hasValidMemoryCache(int pageNumber) =>
      _cacheManager.hasValidMemoryCache(pageNumber);

  @override
  Future<Either<String, ArticlesCategoryModel>> fetchAuthorProfile({
    required String authorName,
    required String language,
    required int pageNumber,
  }) async {
    try {
      // STEP 1: Handle author change (clear cache when switching authors)
      if (_currentAuthorName != authorName) {
        log(
          '👤 [AuthorProfile] Author changed to $authorName - Clearing cache',
        );
        _cacheManager.clearAll();
        _currentAuthorName = authorName;
      }

      // STEP 2: Handle language change
      if (_cacheManager.hasLanguageChanged(language)) {
        _cacheManager.clearAll();
      }
      _cacheManager.setCachedLanguage(language);

      // STEP 3: Check Memory Cache (30 min) - Return immediately without network
      if (_cacheManager.hasValidMemoryCache(pageNumber)) {
        log('💾 [AuthorProfile] Using valid memory cache for page $pageNumber');
        return _buildSuccessResponse(pageNumber);
      }

      // STEP 4: Memory cache expired - Need to revalidate
      log('📡 [AuthorProfile] Making network request for page $pageNumber');

      // STEP 5: Make network request with ETag if available
      final response = await _makeRequest(authorName, language, pageNumber);

      _etagHandler.logResponseStatus(response, pageNumber);

      // STEP 6: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(pageNumber);
      }

      // STEP 7: Handle 200 OK with new data
      return _handle200Response(response, pageNumber);
    } catch (e) {
      return _handleError(e, pageNumber);
    }
  }

  /// Build success response from cached data
  Either<String, ArticlesCategoryModel> _buildSuccessResponse(int pageNumber) {
    return Right(
      ArticlesCategoryModel(
        articles: _cacheManager.getCachedData(pageNumber),
        pageNumber: pageNumber,
        totalPages: _cacheManager.getTotalPages(pageNumber),
      ),
    );
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(
    String authorName,
    String language,
    int pageNumber,
  ) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = _cacheManager.getETag(pageNumber);
    final headers = _etagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.authorName: authorName,
        ApiQueryParams.pageNumber: pageNumber,
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.type: PostType.article.value,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(int pageNumber) {
    log(
      '✅ [AuthorProfile] 304 Not Modified - Using cached data for page $pageNumber',
    );

    if (!_cacheManager.hasCachedData(pageNumber)) {
      log(
        '⚠️ [AuthorProfile] 304 received but no cached data for page $pageNumber',
      );
      return Left("cached_data_missing".tr());
    }

    // Update timestamp to extend cache validity
    _cacheManager.updateTimestamp(pageNumber);

    return _buildSuccessResponse(pageNumber);
  }

  /// Handle 200 OK response with new data
  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    int pageNumber,
  ) {
    log('📦 [AuthorProfile] 200 OK - Received new data for page $pageNumber');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, pageNumber);

    // Parse response
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    // Cache data
    _cacheManager.cachePageData(
      pageNumber: pageNumber,
      data: articles,
      etag: etag,
      totalPages: articlesCategoryModel.totalPages,
    );

    return Right(articlesCategoryModel);
  }

  /// Handle errors with fallback to stale cache
  Either<String, ArticlesCategoryModel> _handleError(
    dynamic error,
    int pageNumber,
  ) {
    log('❌ [AuthorProfile] Error fetching articles: $error');

    // Fallback: Use stale cached data if available
    if (_cacheManager.hasCachedData(pageNumber)) {
      log(
        '⚠️ [AuthorProfile] Network error - Using stale cached data for page $pageNumber',
      );
      return _buildSuccessResponse(pageNumber);
    }

    return Left('Error fetching author profile articles'.tr());
  }

  /// Force refresh - invalidates cache to trigger revalidation
  Future<Either<String, ArticlesCategoryModel>> forceRefresh({
    required String authorName,
    required String language,
  }) async {
    log('🔄 [AuthorProfile] Force refresh requested');
    _cacheManager.invalidateTimestamps();
    return fetchAuthorProfile(
      authorName: authorName,
      language: language,
      pageNumber: 1,
    );
  }

  /// Clear all cache including ETags
  void clearAllCache() {
    _cacheManager.clearAll();
    _currentAuthorName = null;
  }
}
