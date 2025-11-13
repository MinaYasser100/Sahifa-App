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

abstract class AllCategoryArticlesRepo {
  Future<Either<String, ArticlesCategoryModel>> fetchArticleSearchCategory(
    String categorySlug,
    String language, {
    int page = 1,
  });
  void clearCache();
  void refresh();
  bool hasValidCache(String categorySlug, int page);
}

class AllCategoryArticlesRepoImpl implements AllCategoryArticlesRepo {
  // Singleton Pattern
  static final AllCategoryArticlesRepoImpl _instance =
      AllCategoryArticlesRepoImpl._internal();
  factory AllCategoryArticlesRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  AllCategoryArticlesRepoImpl._internal() {
    _etagHandler = GenericETagHandler(handlerIdentifier: 'AllCategoryArticles');
  }

  late DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Separate cache manager for each category
  final Map<String, GenericCacheManager<ArticleModel>> _cacheManagers = {};

  // Get or create cache manager for a category
  GenericCacheManager<ArticleModel> _getCacheManager(String categorySlug) {
    if (!_cacheManagers.containsKey(categorySlug)) {
      _cacheManagers[categorySlug] = GenericCacheManager<ArticleModel>(
        cacheIdentifier: 'AllCategoryArticles_$categorySlug',
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
      return Left('Error fetching articles of this category'.tr());
    }
  }

  /// Build success response from cached data
  Either<String, ArticlesCategoryModel> _buildSuccessResponse(
    GenericCacheManager<ArticleModel> cacheManager,
    int page,
  ) {
    return Right(
      ArticlesCategoryModel(
        articles: cacheManager.getCachedData(page),
        totalPages: cacheManager.getTotalPages(page),
      ),
    );
  }

  /// Make HTTP request with ETag headers
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
      url: ApiEndpoints.articles.path,
      query: {
        ApiQueryParams.categorySlug: categorySlug,
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: page,
        ApiQueryParams.language: backendLanguage,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(
    GenericCacheManager<ArticleModel> cacheManager,
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
  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    GenericCacheManager<ArticleModel> cacheManager,
    int page,
  ) {
    log('📦 200 OK - Received new data for page $page');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, page);

    // Parse response
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    // Cache data
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
