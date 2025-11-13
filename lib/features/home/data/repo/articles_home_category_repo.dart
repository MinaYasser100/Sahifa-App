import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesHomeCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  );
  void clearCache();
}

class ArticlesHomeCategoryRepoImpl implements ArticlesHomeCategoryRepo {
  // Singleton Pattern
  static final ArticlesHomeCategoryRepoImpl _instance =
      ArticlesHomeCategoryRepoImpl._internal();
  factory ArticlesHomeCategoryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  ArticlesHomeCategoryRepoImpl._internal() {
    _etagHandler = GenericETagHandler(
      handlerIdentifier: 'ArticlesHomeCategory',
    );
  }

  late DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Store ETags per category+language (for HTTP caching only)
  final Map<String, String> _etagsByCategory = {};
  // Store last response data for 304 handling
  final Map<String, ArticlesCategoryModel> _lastResponseByCategory = {};

  // Generate cache key
  String _getCacheKey(String categorySlug, String language) {
    return '${categorySlug}_$language';
  }

  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  ) async {
    try {
      final cacheKey = _getCacheKey(categorySlug, language);

      // Make network request with ETag if available
      final response = await _makeRequest(categorySlug, language, cacheKey);

      _etagHandler.logResponseStatus(response, 1);

      // Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(cacheKey);
      }

      // Handle 200 OK with new data
      return _handle200Response(response, cacheKey);
    } catch (e) {
      return Left('Error fetching articles');
    }
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(
    String categorySlug,
    String language,
    String cacheKey,
  ) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );

    final etag = _etagsByCategory[cacheKey];
    final headers = _etagHandler.prepareHeaders(etag, 1);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.categorySlug: categorySlug,
        ApiQueryParams.pageSize: 15,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.type: PostType.article.value,
        ApiQueryParams.includeLikedByUsers: true,
        ApiQueryParams.hasAuthor: false,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(String cacheKey) {
    log('✅ 304 Not Modified - Home category data unchanged for $cacheKey');

    // Return last known response for this category
    if (_lastResponseByCategory.containsKey(cacheKey)) {
      return Right(_lastResponseByCategory[cacheKey]!);
    }

    // If we don't have cached response, this shouldn't happen
    log('⚠️ Warning: 304 received but no cached response for $cacheKey');
    return Left('Error fetching articles');
  }

  /// Handle 200 OK response with new data
  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    String cacheKey,
  ) {
    log('📦 200 OK - Received new home category data for $cacheKey');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, 1);
    if (etag != null) {
      _etagsByCategory[cacheKey] = etag;
    }

    // Parse response
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);

    // Store last response for 304 handling
    _lastResponseByCategory[cacheKey] = articlesCategoryModel;

    return Right(articlesCategoryModel);
  }

  // Clear all cache
  @override
  void clearCache() {
    _etagsByCategory.clear();
    _lastResponseByCategory.clear();
  }
}
