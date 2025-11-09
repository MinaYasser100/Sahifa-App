import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';

abstract class MyFavoriteRepo {
  Future<Either<String, ArticlesCategoryModel>> fetchFavorites({
    required int pageNumber,
  });
}

class MyFavoriteRepoImpl implements MyFavoriteRepo {
  // Singleton Pattern
  static final MyFavoriteRepoImpl _instance = MyFavoriteRepoImpl._internal(
    DioHelper(),
  );
  factory MyFavoriteRepoImpl() => _instance;

  MyFavoriteRepoImpl._internal(this._dioHelper) {
    _etagHandler = GenericETagHandler(handlerIdentifier: 'Favorites');
  }

  final DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Store ETags per page (for HTTP caching only)
  final Map<int, String> _etagsByPage = {};
  // Store last response data for 304 handling
  final Map<int, ArticlesCategoryModel> _lastResponseByPage = {};

  @override
  Future<Either<String, ArticlesCategoryModel>> fetchFavorites({
    required int pageNumber,
  }) async {
    try {
      // Make network request with ETag if available
      final response = await _makeRequest(pageNumber);

      _etagHandler.logResponseStatus(response, pageNumber);

      // Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(pageNumber);
      }

      // Handle 200 OK with new data
      return _handle200Response(response, pageNumber);
    } catch (e) {
      return Left("failed_to_load_favorites".tr());
    }
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(int pageNumber) async {
    final etag = _etagsByPage[pageNumber];
    final headers = _etagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.getLikePosts.path,
      query: {
        ApiQueryParams.includeLikedByUsers: true,
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: pageNumber,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, ArticlesCategoryModel> _handle304Response(int pageNumber) {
    log('✅ 304 Not Modified - Favorites data unchanged for page $pageNumber');

    // Return last known response for this page
    if (_lastResponseByPage.containsKey(pageNumber)) {
      return Right(_lastResponseByPage[pageNumber]!);
    }

    // If we don't have cached response, this shouldn't happen
    log('⚠️ Warning: 304 received but no cached response for page $pageNumber');
    return Left("cached_data_missing".tr());
  }

  /// Handle 200 OK response with new data
  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    int pageNumber,
  ) {
    log('📦 200 OK - Received new favorites data for page $pageNumber');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, pageNumber);
    if (etag != null) {
      _etagsByPage[pageNumber] = etag;
    }

    // Parse response
    final favoritesModel = ArticlesCategoryModel.fromJson(response.data);

    // Store last response for 304 handling
    _lastResponseByPage[pageNumber] = favoritesModel;

    return Right(favoritesModel);
  }

  /// Force refresh - clears ETags to force new data
  Future<Either<String, ArticlesCategoryModel>> forceRefresh() async {
    log('🔄 Force refresh requested - Clearing ETags');
    _etagsByPage.clear();
    _lastResponseByPage.clear();
    return fetchFavorites(pageNumber: 1);
  }

  /// Clear all data (for logout)
  void clearAllCache() {
    _etagsByPage.clear();
    _lastResponseByPage.clear();
  }
}
