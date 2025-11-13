import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';

abstract class DetailsArticleRepo {
  Future<Either<String, ArticleModel>> getArticleDetails({
    required String articleSlug,
    required String categorySlug,
  });
}

class DetailsArticleRepoImpl implements DetailsArticleRepo {
  // Singleton Pattern
  static final DetailsArticleRepoImpl _instance =
      DetailsArticleRepoImpl._internal(getIt<DioHelper>());
  factory DetailsArticleRepoImpl() => _instance;

  DetailsArticleRepoImpl._internal(this._dioHelper) {
    _etagHandler = GenericETagHandler(handlerIdentifier: 'DetailsArticle');
  }

  final DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Store ETags per article (for HTTP caching only)
  final Map<String, String> _etagsByArticle = {};
  // Store last response data for 304 handling
  final Map<String, ArticleModel> _lastResponseByArticle = {};

  // Generate cache key from article and category slug
  String _getCacheKey(String articleSlug, String categorySlug) {
    return '${categorySlug}_$articleSlug';
  }

  @override
  Future<Either<String, ArticleModel>> getArticleDetails({
    required String articleSlug,
    required String categorySlug,
  }) async {
    try {
      final cacheKey = _getCacheKey(articleSlug, categorySlug);

      // Make network request with ETag if available
      final response = await _makeRequest(articleSlug, categorySlug, cacheKey);

      _etagHandler.logResponseStatus(response, 1);

      // Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(cacheKey);
      }

      // Handle 200 OK with new data
      return _handle200Response(response, cacheKey);
    } catch (e) {
      log("Error fetching article details: $e");
      return Left("Error fetching article details".tr());
    }
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(
    String articleSlug,
    String categorySlug,
    String cacheKey,
  ) async {
    // Replace path parameters
    final url = ApiEndpoints.articleDetails.withParams({
      'categorySlug': categorySlug,
      'slug': articleSlug,
    });

    final etag = _etagsByArticle[cacheKey];
    final headers = _etagHandler.prepareHeaders(etag, 1);

    return await _dioHelper.getData(url: url, headers: headers);
  }

  /// Handle 304 Not Modified response
  Either<String, ArticleModel> _handle304Response(String cacheKey) {
    log('✅ 304 Not Modified - Article data unchanged for $cacheKey');

    // Return last known response for this article
    if (_lastResponseByArticle.containsKey(cacheKey)) {
      return Right(_lastResponseByArticle[cacheKey]!);
    }

    // If we don't have cached response, this shouldn't happen
    log('⚠️ Warning: 304 received but no cached response for $cacheKey');
    return Left("cached_data_missing".tr());
  }

  /// Handle 200 OK response with new data
  Either<String, ArticleModel> _handle200Response(
    Response response,
    String cacheKey,
  ) {
    log('📦 200 OK - Received new article data for $cacheKey');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, 1);
    if (etag != null) {
      _etagsByArticle[cacheKey] = etag;
    }

    // Check if response.data is directly the article object or wrapped in 'data'
    final articleData =
        response.data is Map<String, dynamic> &&
            response.data.containsKey('data')
        ? response.data['data']
        : response.data;

    final ArticleModel articleModel = ArticleModel.fromJson(articleData);

    // Store last response for 304 handling
    _lastResponseByArticle[cacheKey] = articleModel;

    return Right(articleModel);
  }

  /// Force refresh - clears ETags to force new data
  Future<Either<String, ArticleModel>> forceRefresh({
    required String articleSlug,
    required String categorySlug,
  }) async {
    final cacheKey = _getCacheKey(articleSlug, categorySlug);
    log('🔄 Force refresh requested - Clearing ETag for $cacheKey');
    _etagsByArticle.remove(cacheKey);
    _lastResponseByArticle.remove(cacheKey);
    return getArticleDetails(
      articleSlug: articleSlug,
      categorySlug: categorySlug,
    );
  }

  /// Clear all cache
  void clearAllCache() {
    _etagsByArticle.clear();
    _lastResponseByArticle.clear();
  }
}
