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

abstract class ArticlesHorizontalBooksOpinionsRepo {
  Future<Either<String, ArticlesCategoryModel>>
  fetchArticlesHorizontalBooksOpinions(String language);
}

class ArticlesHorizontalBooksOpinionsRepoImpl
    implements ArticlesHorizontalBooksOpinionsRepo {
  // Singleton Pattern
  static final ArticlesHorizontalBooksOpinionsRepoImpl _instance =
      ArticlesHorizontalBooksOpinionsRepoImpl._internal(DioHelper());
  factory ArticlesHorizontalBooksOpinionsRepoImpl() => _instance;

  ArticlesHorizontalBooksOpinionsRepoImpl._internal(this._dioHelper) {
    _cacheManager = GenericCacheManager<ArticleModel>(
      cacheIdentifier: 'HorizontalBooksOpinions',
    );
    _etagHandler = GenericETagHandler(
      handlerIdentifier: 'HorizontalBooksOpinions',
    );
  }

  final DioHelper _dioHelper;
  late final GenericCacheManager<ArticleModel> _cacheManager;
  late final GenericETagHandler _etagHandler;

  // Fixed page number (no pagination)
  static const int _pageNumber = 1;

  // Public getters for Cubit
  bool hasValidMemoryCache() => _cacheManager.hasValidMemoryCache(_pageNumber);

  @override
  Future<Either<String, ArticlesCategoryModel>>
  fetchArticlesHorizontalBooksOpinions(String language) async {
    try {
      // STEP 1: Handle language change
      if (_cacheManager.hasLanguageChanged(language)) {
        _cacheManager.clearAll();
      }
      _cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache (30 min) - Return immediately without network
      if (_cacheManager.hasValidMemoryCache(_pageNumber)) {
        log('💾 [HorizontalBooksOpinions] Using valid memory cache');
        return _buildSuccessResponse();
      }

      // STEP 3: Memory cache expired - Need to revalidate
      log('📡 [HorizontalBooksOpinions] Making network request');

      // STEP 4: Make network request with ETag if available
      final response = await _makeRequest(language);

      _etagHandler.logResponseStatus(response, _pageNumber);

      // STEP 5: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response();
      }

      // STEP 6: Handle 200 OK with new data
      return _handle200Response(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Build success response from cached data
  Either<String, ArticlesCategoryModel> _buildSuccessResponse() {
    return Right(
      ArticlesCategoryModel(
        articles: _cacheManager.getCachedData(_pageNumber),
        pageNumber: _pageNumber,
        totalPages: _cacheManager.getTotalPages(_pageNumber),
      ),
    );
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(String language) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = _cacheManager.getETag(_pageNumber);
    final headers = _etagHandler.prepareHeaders(etag, _pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.pageSize: 15,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.type: PostType.article.value,
        ApiQueryParams.includeLikedByUsers: true,
        ApiQueryParams.hasAuthor: true,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response() {
    log('✅ [HorizontalBooksOpinions] 304 Not Modified - Using cached data');

    if (!_cacheManager.hasCachedData(_pageNumber)) {
      log('⚠️ [HorizontalBooksOpinions] 304 received but no cached data');
      return Left("cached_data_missing".tr());
    }

    // Update timestamp to extend cache validity
    _cacheManager.updateTimestamp(_pageNumber);

    return _buildSuccessResponse();
  }

  /// Handle 200 OK response with new data
  Either<String, ArticlesCategoryModel> _handle200Response(Response response) {
    log('📦 [HorizontalBooksOpinions] 200 OK - Received new data');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, _pageNumber);

    // Parse response
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    // Cache data
    _cacheManager.cachePageData(
      pageNumber: _pageNumber,
      data: articles,
      etag: etag,
      totalPages: articlesCategoryModel.totalPages,
    );

    return Right(articlesCategoryModel);
  }

  /// Handle errors with fallback to stale cache
  Either<String, ArticlesCategoryModel> _handleError(dynamic error) {
    log('❌ [HorizontalBooksOpinions] Error fetching articles: $error');

    // Fallback: Use stale cached data if available
    if (_cacheManager.hasCachedData(_pageNumber)) {
      log(
        '⚠️ [HorizontalBooksOpinions] Network error - Using stale cached data',
      );
      return _buildSuccessResponse();
    }

    return Left('Error fetching horizontal books & opinions articles'.tr());
  }

  /// Force refresh - invalidates cache to trigger revalidation
  Future<Either<String, ArticlesCategoryModel>> forceRefresh({
    required String language,
  }) async {
    log('🔄 [HorizontalBooksOpinions] Force refresh requested');
    _cacheManager.invalidateTimestamps();
    return fetchArticlesHorizontalBooksOpinions(language);
  }

  /// Clear all cache including ETags
  void clearAllCache() {
    _cacheManager.clearAll();
  }
}
