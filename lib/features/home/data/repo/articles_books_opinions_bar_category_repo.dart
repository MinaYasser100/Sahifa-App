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

abstract class ArticlesBooksOpinionsBarCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>>
  fetchArticlesBooksOpinionsBarCategory({
    required String language,
    required int pageNumber,
  });
}

class ArticlesBooksOpinionsBarCategoryRepoImpl
    implements ArticlesBooksOpinionsBarCategoryRepo {
  // Singleton Pattern
  static final ArticlesBooksOpinionsBarCategoryRepoImpl _instance =
      ArticlesBooksOpinionsBarCategoryRepoImpl._internal(DioHelper());
  factory ArticlesBooksOpinionsBarCategoryRepoImpl() => _instance;

  ArticlesBooksOpinionsBarCategoryRepoImpl._internal(this._dioHelper) {
    _cacheManager = GenericCacheManager<ArticleModel>(
      cacheIdentifier: 'BooksOpinions',
    );
    _etagHandler = GenericETagHandler(handlerIdentifier: 'BooksOpinions');
  }

  final DioHelper _dioHelper;
  late final GenericCacheManager<ArticleModel> _cacheManager;
  late final GenericETagHandler _etagHandler;

  // Public getters for Cubit
  bool hasValidMemoryCache(int pageNumber) =>
      _cacheManager.hasValidMemoryCache(pageNumber);

  @override
  Future<Either<String, ArticlesCategoryModel>>
  fetchArticlesBooksOpinionsBarCategory({
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
        log('💾 [BooksOpinions] Using valid memory cache for page $pageNumber');
        return _buildSuccessResponse(pageNumber);
      }

      // STEP 3: Memory cache expired - Need to revalidate
      log('📡 [BooksOpinions] Making network request for page $pageNumber');

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
  Future<Response> _makeRequest(String language, int pageNumber) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = _cacheManager.getETag(pageNumber);
    final headers = _etagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: pageNumber,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.type: PostType.article.value,
        ApiQueryParams.includeLikedByUsers: true,
        ApiQueryParams.hasAuthor: true,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(int pageNumber) {
    log(
      '✅ [BooksOpinions] 304 Not Modified - Using cached data for page $pageNumber',
    );

    if (!_cacheManager.hasCachedData(pageNumber)) {
      log(
        '⚠️ [BooksOpinions] 304 received but no cached data for page $pageNumber',
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
    log('📦 [BooksOpinions] 200 OK - Received new data for page $pageNumber');

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
    log('❌ [BooksOpinions] Error fetching articles: $error');

    // Fallback: Use stale cached data if available
    if (_cacheManager.hasCachedData(pageNumber)) {
      log(
        '⚠️ [BooksOpinions] Network error - Using stale cached data for page $pageNumber',
      );
      return _buildSuccessResponse(pageNumber);
    }

    return Left(
      'Error fetching articles of books and opinions for bar category'.tr(),
    );
  }

  /// Force refresh - invalidates cache to trigger revalidation
  Future<Either<String, ArticlesCategoryModel>> forceRefresh({
    required String language,
  }) async {
    log('🔄 [BooksOpinions] Force refresh requested');
    _cacheManager.invalidateTimestamps();
    return fetchArticlesBooksOpinionsBarCategory(
      language: language,
      pageNumber: 1,
    );
  }

  /// Clear all cache including ETags
  void clearAllCache() {
    _cacheManager.clearAll();
  }
}
