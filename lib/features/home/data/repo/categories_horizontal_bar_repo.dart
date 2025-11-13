import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class CategoriesHorizontalBarRepo {
  Future<Either<String, List<ParentCategory>>> fetchCategoriesHorizontalBar(
    String language,
  );
  void clearCache();
}

class CategoriesHorizontalBarRepoImpl implements CategoriesHorizontalBarRepo {
  // Singleton Pattern
  static final CategoriesHorizontalBarRepoImpl _instance =
      CategoriesHorizontalBarRepoImpl._internal();
  factory CategoriesHorizontalBarRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  CategoriesHorizontalBarRepoImpl._internal() {
    _etagHandler = GenericETagHandler(
      handlerIdentifier: 'CategoriesHorizontalBar',
    );
  }

  late DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Store ETags per language (for HTTP caching only)
  final Map<String, String> _etagsByLanguage = {};
  // Store last response data for 304 handling
  final Map<String, List<ParentCategory>> _lastResponseByLanguage = {};

  @override
  Future<Either<String, List<ParentCategory>>> fetchCategoriesHorizontalBar(
    String language,
  ) async {
    try {
      // Make network request with ETag if available
      final response = await _makeRequest(language);

      _etagHandler.logResponseStatus(response, 1);

      // Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(language);
      }

      // Handle 200 OK with new data
      return _handle200Response(response, language);
    } catch (e) {
      return Left("Error fetching categories".tr());
    }
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(String language) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );

    final etag = _etagsByLanguage[language];
    final headers = _etagHandler.prepareHeaders(etag, 1);

    return await _dioHelper.getData(
      url: ApiEndpoints.parentCategories.path,
      query: {
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.isActive: true,
        ApiQueryParams.showOnHomepage: true,
      },
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, List<ParentCategory>> _handle304Response(String language) {
    log('✅ 304 Not Modified - Categories unchanged for $language');

    if (_lastResponseByLanguage.containsKey(language)) {
      return Right(_lastResponseByLanguage[language]!);
    }

    log('⚠️ Warning: 304 received but no cached response for $language');
    return Left("Error fetching categories".tr());
  }

  /// Handle 200 OK response with new data
  Either<String, List<ParentCategory>> _handle200Response(
    Response response,
    String language,
  ) {
    log('📦 200 OK - Received new categories for $language');

    // Extract and store ETag
    final etag = _etagHandler.extractETag(response, 1);
    if (etag != null) {
      _etagsByLanguage[language] = etag;
    }

    // Parse response
    final List<ParentCategory> parentCategories = (response.data as List)
        .map((e) => ParentCategory.fromJson(e))
        .toList();

    // Store last response for 304 handling
    _lastResponseByLanguage[language] = parentCategories;

    return Right(parentCategories);
  }

  // Force refresh - clears cache and fetches new data
  Future<Either<String, List<ParentCategory>>> forceRefresh(
    String language,
  ) async {
    clearCache();
    return await fetchCategoriesHorizontalBar(language);
  }

  // Clear cache manually
  @override
  void clearCache() {
    _etagsByLanguage.clear();
    _lastResponseByLanguage.clear();
  }
}
