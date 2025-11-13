import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class SearchCategoriesRepo {
  Future<Either<String, List<ParentCategory>>> fetchSearchCategories(
    String language,
  );
}

class SearchCategoriesRepoImpl implements SearchCategoriesRepo {
  // Singleton Pattern
  static final SearchCategoriesRepoImpl _instance =
      SearchCategoriesRepoImpl._internal();
  factory SearchCategoriesRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  SearchCategoriesRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache with ETag support
  List<ParentCategory>? _cachedCategories;
  DateTime? _lastFetchTime;
  String? _lastLanguage; // Track language changes
  String? _etag; // ETag for conditional requests
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status
  bool get hasValidCache =>
      _cachedCategories != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ParentCategory>>> fetchSearchCategories(
    String language,
  ) async {
    try {
      // Check language change
      if (_lastLanguage != null && _lastLanguage != language) {
        clearCache();
      }
      _lastLanguage = language;

      // Check if cached data exists and is fresh
      if (_cachedCategories != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        log('💾 Using valid cache for search categories');
        return Right(_cachedCategories!);
      }

      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      // Prepare ETag headers
      final headers = <String, dynamic>{};
      if (_etag != null) {
        headers['If-None-Match'] = _etag;
        log('🏷️ Sending ETag for search categories: $_etag');
      } else {
        log('🆕 No ETag for search categories - First request');
      }

      // Fetch from API with ETag
      final result = await _dioHelper.getData(
        url: ApiEndpoints.parentCategories.path,
        query: {
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.isActive: true,
        },
        headers: headers.isNotEmpty ? headers : null,
      );

      log('📥 Response status: ${result.statusCode} for search categories');

      // Handle 304 Not Modified
      if (result.statusCode == 304) {
        log('✅ 304 Not Modified - Search categories unchanged');
        if (_cachedCategories != null) {
          _lastFetchTime = DateTime.now();
          return Right(_cachedCategories!);
        }
        return Left("Failed to fetch search categories".tr());
      }

      // Handle 200 OK - new data
      log('📦 200 OK - Received new search categories');
      final List<ParentCategory> parentCategories = (result.data as List)
          .map((e) => ParentCategory.fromJson(e))
          .toList();

      // Update cache
      _cachedCategories = parentCategories;
      _lastFetchTime = DateTime.now();

      // Store ETag
      if (result.headers.value('etag') != null) {
        _etag = result.headers.value('etag')!;
        log('📦 Stored ETag for search categories');
      }

      return Right(parentCategories);
    } catch (e) {
      return Left("Failed to fetch search categories".tr());
    }
  }

  // Force refresh - clears cache and fetches new data
  Future<Either<String, List<ParentCategory>>> forceRefresh(
    String language,
  ) async {
    clearCache();
    return await fetchSearchCategories(language);
  }

  // Clear cache manually
  void clearCache() {
    _cachedCategories = null;
    _lastFetchTime = null;
    _lastLanguage = null;
    _etag = null;
  }
}
