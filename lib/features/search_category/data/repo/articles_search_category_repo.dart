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

abstract class ArticlesSearchCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> fetchArticleSearchCategory(
    String categorySlug,
    String language, {
    int page = 1,
  });
  bool hasValidCache(String categorySlug, int page);
  void clearCache();
  void refresh();
}

class ArticlesSearchCategoryRepoImpl implements ArticlesSearchCategoryRepo {
  // Singleton Pattern
  static final ArticlesSearchCategoryRepoImpl _instance =
      ArticlesSearchCategoryRepoImpl._internal();
  factory ArticlesSearchCategoryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  ArticlesSearchCategoryRepoImpl._internal() {
    _etagHandler = GenericETagHandler(
      handlerIdentifier: 'ArticlesSearchCategory',
    );
  }

  late DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Separate cache manager for each category
  final Map<String, GenericCacheManager<ArticleModel>> _cacheManagers = {};

  // Get or create cache manager for a category
  GenericCacheManager<ArticleModel> _getCacheManager(String categorySlug) {
    if (!_cacheManagers.containsKey(categorySlug)) {
      _cacheManagers[categorySlug] = GenericCacheManager<ArticleModel>(
        cacheIdentifier: 'ArticlesSearchCategory_$categorySlug',
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
  Future<Either<String, ArticlesCategoryModel>> fetchArticleSearchCategory(
    String categorySlug,
    String language, {
    int page = 1,
  }) async {
    try {
      final cacheManager = _getCacheManager(categorySlug);

      // STEP 1: Handle language change
      if (cacheManager.hasLanguageChanged(language)) {
        cacheManager.clearAll();
      }
      cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache
      if (cacheManager.hasValidMemoryCache(page)) {
        log('💾 Using valid memory cache for $categorySlug page $page');
        return _buildSuccessResponse(cacheManager, page);
      }

      // STEP 3: Make network request
      log('📡 Making network request for $categorySlug page $page');
      final response = await _makeRequest(
        categorySlug,
        language,
        page,
        cacheManager,
      );

      _etagHandler.logResponseStatus(response, page);

      // STEP 4: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(cacheManager, page);
      }

      // STEP 5: Handle 200 OK with new data
      return _handle200Response(response, cacheManager, page);
    } catch (e) {
      return Left('Error fetching articles of this category'.tr());
    }
  }

  Either<String, ArticlesCategoryModel> _buildSuccessResponse(
    GenericCacheManager<ArticleModel> cacheManager,
    int page,
  ) {
    return Right(
      ArticlesCategoryModel(
        articles: cacheManager.getCachedData(page),
        pageNumber: page,
        totalPages: cacheManager.getTotalPages(page),
      ),
    );
  }

  Future<Response> _makeRequest(
    String categorySlug,
    String language,
    int page,
    GenericCacheManager<ArticleModel> cacheManager,
  ) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = cacheManager.getETag(page);
    final headers = _etagHandler.prepareHeaders(etag, page);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.categorySlug: categorySlug,
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: page,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.hasAuthor: false,
        ApiQueryParams.type: PostType.article.value,
        ApiQueryParams.includeLikedByUsers: true,
      },
      headers: headers,
    );
  }

  Either<String, ArticlesCategoryModel> _handle304Response(
    GenericCacheManager<ArticleModel> cacheManager,
    int page,
  ) {
    log('✅ 304 Not Modified - Data unchanged for page $page');
    if (!cacheManager.hasCachedData(page)) {
      return Left('Error fetching articles of this category'.tr());
    }
    cacheManager.updateTimestamp(page);
    return _buildSuccessResponse(cacheManager, page);
  }

  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    GenericCacheManager<ArticleModel> cacheManager,
    int page,
  ) {
    log('📦 200 OK - Received new data for page $page');
    final etag = _etagHandler.extractETag(response, page);
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    cacheManager.cachePageData(
      pageNumber: page,
      data: articles,
      etag: etag,
      totalPages: articlesCategoryModel.totalPages,
    );

    return Right(articlesCategoryModel);
  }

  @override
  void clearCache() {
    for (final manager in _cacheManagers.values) {
      manager.clearAll();
    }
    _cacheManagers.clear();
  }

  @override
  void refresh() {
    clearCache();
  }
}
