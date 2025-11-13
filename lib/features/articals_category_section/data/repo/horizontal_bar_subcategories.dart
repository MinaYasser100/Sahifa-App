import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/model/parent_category/subcategory_info_model.dart';

abstract class HorizontalBarSubcategoriesRepo {
  Future<Either<String, List<SubcategoryInfoModel>>>
  getSubcategoriesByParentCategory({required String parentCategorySlug});
  void clearCache();
  void refresh();
}

class HorizontalBarSubcategoriesRepoImpl
    implements HorizontalBarSubcategoriesRepo {
  // Singleton Pattern
  static final HorizontalBarSubcategoriesRepoImpl _instance =
      HorizontalBarSubcategoriesRepoImpl._internal();
  factory HorizontalBarSubcategoriesRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  HorizontalBarSubcategoriesRepoImpl._internal() {
    _etagHandler = GenericETagHandler(
      handlerIdentifier: 'HorizontalBarSubcategories',
    );
  }

  late DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Store ETags per category (for HTTP caching only)
  final Map<String, String> _etagsByCategory = {};
  // Store last response data for 304 handling
  final Map<String, List<SubcategoryInfoModel>> _lastResponseByCategory = {};

  @override
  Future<Either<String, List<SubcategoryInfoModel>>>
  getSubcategoriesByParentCategory({required String parentCategorySlug}) async {
    try {
      // Make network request with ETag if available
      final response = await _makeRequest(parentCategorySlug);

      _etagHandler.logResponseStatus(response, 1);

      // Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(parentCategorySlug);
      }

      // Handle 200 OK with new data
      return _handle200Response(response, parentCategorySlug);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(String parentCategorySlug) async {
    final etag = _etagsByCategory[parentCategorySlug];
    final headers = _etagHandler.prepareHeaders(etag, 1);

    return await _dioHelper.getData(
      url: ApiEndpoints.categoryInfoBySlug.withParams({
        'slug': parentCategorySlug,
      }),
      query: {ApiQueryParams.withSub: true},
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, List<SubcategoryInfoModel>> _handle304Response(
    String parentCategorySlug,
  ) {
    log('✅ 304 Not Modified - Subcategories unchanged for $parentCategorySlug');

    if (_lastResponseByCategory.containsKey(parentCategorySlug)) {
      return Right(_lastResponseByCategory[parentCategorySlug]!);
    }

    log(
      '⚠️ Warning: 304 received but no cached response for $parentCategorySlug',
    );
    return Left('Cached data missing');
  }

  /// Handle 200 OK response with new data
  Either<String, List<SubcategoryInfoModel>> _handle200Response(
    Response response,
    String parentCategorySlug,
  ) {
    log('📦 200 OK - Received new subcategories for $parentCategorySlug');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, 1);
    if (etag != null) {
      _etagsByCategory[parentCategorySlug] = etag;
    }

    // Parse response
    final ParentCategory parentCategory = ParentCategory.fromJson(
      response.data,
    );
    final subcategories = parentCategory.subcategories ?? [];

    // Store last response for 304 handling
    _lastResponseByCategory[parentCategorySlug] = subcategories;

    return Right(subcategories);
  }

  @override
  void clearCache() {
    _etagsByCategory.clear();
    _lastResponseByCategory.clear();
  }

  @override
  void refresh() {
    clearCache();
  }
}
