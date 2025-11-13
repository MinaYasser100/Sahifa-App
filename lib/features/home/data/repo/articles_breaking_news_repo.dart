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

abstract class ArticlesBreakingNewsRepo {
  Future<Either<String, ArticlesCategoryModel>> getBreakingNewsArticles(
    String language, {
    int page = 1,
  });
  bool hasValidCache(int page);
  void clearCache();
  void refresh();
}

class ArticlesBreakingNewsRepoImpl implements ArticlesBreakingNewsRepo {
  // Singleton Pattern
  static final ArticlesBreakingNewsRepoImpl _instance =
      ArticlesBreakingNewsRepoImpl._internal();
  factory ArticlesBreakingNewsRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  ArticlesBreakingNewsRepoImpl._internal() {
    _cacheManager = GenericCacheManager<ArticleModel>(
      cacheIdentifier: 'BreakingNews',
    );
    _etagHandler = GenericETagHandler(handlerIdentifier: 'BreakingNews');
  }

  late DioHelper _dioHelper;
  late final GenericCacheManager<ArticleModel> _cacheManager;
  late final GenericETagHandler _etagHandler;

  // Public getter for cache validation
  @override
  bool hasValidCache(int page) => _cacheManager.hasValidMemoryCache(page);

  @override
  Future<Either<String, ArticlesCategoryModel>> getBreakingNewsArticles(
    String language, {
    int page = 1,
  }) async {
    try {
      // STEP 1: Handle language change
      if (_cacheManager.hasLanguageChanged(language)) {
        _cacheManager.clearAll();
      }
      _cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache (30 min)
      if (_cacheManager.hasValidMemoryCache(page)) {
        log('💾 Using valid memory cache for breaking news page $page');
        return _buildSuccessResponse(page);
      }

      // STEP 3: Memory cache expired - Need to revalidate
      log('📡 Making network request for breaking news page $page');

      // STEP 4: Make network request with ETag if available
      final response = await _makeRequest(language, page);

      _etagHandler.logResponseStatus(response, page);

      // STEP 5: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(page);
      }

      // STEP 6: Handle 200 OK with new data
      return _handle200Response(response, page);
    } catch (e) {
      return Left('Error fetching breaking news articles'.tr());
    }
  }

  /// Build success response from cached data
  Either<String, ArticlesCategoryModel> _buildSuccessResponse(int page) {
    return Right(
      ArticlesCategoryModel(
        articles: _cacheManager.getCachedData(page),
        pageNumber: page,
        totalPages: _cacheManager.getTotalPages(page),
      ),
    );
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(String language, int page) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = _cacheManager.getETag(page);
    final headers = _etagHandler.prepareHeaders(etag, page);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: page,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.isBreaking: true,
        ApiQueryParams.type: PostType.article.value,
        ApiQueryParams.includeLikedByUsers: true,
        ApiQueryParams.hasAuthor: false,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(int page) {
    log('✅ 304 Not Modified - Breaking news data unchanged for page $page');

    if (!_cacheManager.hasCachedData(page)) {
      log('⚠️ Warning: 304 received but no cached data found for page $page');
      return Left('Error fetching breaking news articles'.tr());
    }

    // Update timestamp to extend cache validity
    _cacheManager.updateTimestamp(page);

    return _buildSuccessResponse(page);
  }

  /// Handle 200 OK response with new data
  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    int page,
  ) {
    log('📦 200 OK - Received new breaking news data for page $page');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, page);

    // Parse response
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    // Cache data
    _cacheManager.cachePageData(
      pageNumber: page,
      data: articles,
      etag: etag,
      totalPages: articlesCategoryModel.totalPages,
    );

    return Right(articlesCategoryModel);
  }

  @override
  void clearCache() {
    _cacheManager.clearAll();
  }

  @override
  void refresh() {
    clearCache();
  }
}
