import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sahifa/core/cache/generic_cache_manager.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesHorizontalBarCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory({
    required String categorySlug,
    required String language,
    required int pageNumber,
  });
  bool hasValidCache(String categorySlug, int pageNumber);
  void clearCache(String categorySlug);
}

class ArticlesHorizontalBarCategoryRepoImpl
    implements ArticlesHorizontalBarCategoryRepo {
  // Singleton instance
  static final ArticlesHorizontalBarCategoryRepoImpl _instance =
      ArticlesHorizontalBarCategoryRepoImpl._internal(DioHelper());

  factory ArticlesHorizontalBarCategoryRepoImpl(DioHelper dioHelper) {
    return _instance;
  }

  ArticlesHorizontalBarCategoryRepoImpl._internal(this._dioHelper) {
    _etagHandler = GenericETagHandler(
      handlerIdentifier: 'ArticlesHorizontalBarCategory',
    );
  }

  final DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Separate cache manager for each category
  final Map<String, GenericCacheManager<ArticleModel>> _cacheManagers = {};

  // Get or create cache manager for a category
  GenericCacheManager<ArticleModel> _getCacheManager(String categorySlug) {
    if (!_cacheManagers.containsKey(categorySlug)) {
      _cacheManagers[categorySlug] = GenericCacheManager<ArticleModel>(
        cacheIdentifier: 'ArticlesHorizontalBarCategory_$categorySlug',
      );
    }
    return _cacheManagers[categorySlug]!;
  }

  @override
  bool hasValidCache(String categorySlug, int pageNumber) {
    final cacheManager = _getCacheManager(categorySlug);
    return cacheManager.hasValidMemoryCache(pageNumber);
  }

  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory({
    required String categorySlug,
    required String language,
    required int pageNumber,
  }) async {
    try {
      final cacheManager = _getCacheManager(categorySlug);

      // STEP 1: Handle language change
      if (cacheManager.hasLanguageChanged(language)) {
        cacheManager.clearAll();
      }
      cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache (30 min) - Return immediately without network
      if (cacheManager.hasValidMemoryCache(pageNumber)) {
        log('💾 Using valid memory cache for $categorySlug page $pageNumber');
        return _buildSuccessResponse(cacheManager, pageNumber);
      }

      // STEP 3: Memory cache expired - Need to revalidate
      log(
        '📡 Memory cache expired for $categorySlug page $pageNumber - Making network request',
      );

      // STEP 4: Make network request with ETag if available
      final response = await _makeRequest(
        categorySlug,
        language,
        pageNumber,
        cacheManager,
      );

      _etagHandler.logResponseStatus(response, pageNumber);

      // STEP 5: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(cacheManager, pageNumber);
      }

      // STEP 6: Handle 200 OK with new data
      return _handle200Response(response, cacheManager, pageNumber);
    } catch (e) {
      return Left('Error fetching articles: ${e.toString()}');
    }
  }

  /// Build success response from cached data
  Either<String, ArticlesCategoryModel> _buildSuccessResponse(
    GenericCacheManager<ArticleModel> cacheManager,
    int pageNumber,
  ) {
    return Right(
      ArticlesCategoryModel(
        articles: cacheManager.getCachedData(pageNumber),
        pageNumber: pageNumber,
        totalPages: cacheManager.getTotalPages(pageNumber),
      ),
    );
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(
    String categorySlug,
    String language,
    int pageNumber,
    GenericCacheManager<ArticleModel> cacheManager,
  ) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = cacheManager.getETag(pageNumber);
    final headers = _etagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.categorySlug: categorySlug,
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: pageNumber,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.type: PostType.article.value,
        ApiQueryParams.includeLikedByUsers: true,
        ApiQueryParams.hasAuthor: false,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(
    GenericCacheManager<ArticleModel> cacheManager,
    int pageNumber,
  ) {
    log(
      '✅ 304 Not Modified - Data unchanged, using cached data for page $pageNumber',
    );

    if (!cacheManager.hasCachedData(pageNumber)) {
      log(
        '⚠️ Warning: 304 received but no cached data found for page $pageNumber',
      );
      return Left('Error fetching articles');
    }

    // Update timestamp to extend cache validity
    cacheManager.updateTimestamp(pageNumber);

    return _buildSuccessResponse(cacheManager, pageNumber);
  }

  /// Handle 200 OK response with new data
  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    GenericCacheManager<ArticleModel> cacheManager,
    int pageNumber,
  ) {
    log('📦 200 OK - Received new data for page $pageNumber');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, pageNumber);

    // Parse response
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    // Cache data
    cacheManager.cachePageData(
      pageNumber: pageNumber,
      data: articles,
      etag: etag,
      totalPages: articlesCategoryModel.totalPages,
    );

    return Right(articlesCategoryModel);
  }

  // Force refresh - clears cache for specific category
  @override
  void clearCache(String categorySlug) {
    final cacheManager = _getCacheManager(categorySlug);
    cacheManager.clearAll();
  }
}
