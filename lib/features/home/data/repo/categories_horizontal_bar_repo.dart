import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';

abstract class CategoriesHorizontalBarRepo {
  Future<Either<String, List<ParentCategory>>> fetchCategoriesHorizontalBar(
    String language,
  );
}

class CategoriesHorizontalBarRepoImpl implements CategoriesHorizontalBarRepo {
  // Singleton Pattern
  static final CategoriesHorizontalBarRepoImpl _instance =
      CategoriesHorizontalBarRepoImpl._internal();
  factory CategoriesHorizontalBarRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  CategoriesHorizontalBarRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache
  List<ParentCategory>? _cachedCategories;
  DateTime? _lastFetchTime;
  String? _lastLanguage; // Track language changes
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status
  bool get hasValidCache =>
      _cachedCategories != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ParentCategory>>> fetchCategoriesHorizontalBar(
    String language,
  ) async {
    try {
      // Check if cached data exists, is fresh, and language hasn't changed
      if (_cachedCategories != null &&
          _lastFetchTime != null &&
          _lastLanguage == language &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedCategories!);
      }

      // If no cache or cache expired or language changed, fetch from API
      final result = await _dioHelper.getData(
        url: ApiEndpoints.parentCategories.path,
        query: {ApiQueryParams.language: 1},
      );
      final List<ParentCategory> parentCategories = (result.data as List)
          .map((e) => ParentCategory.fromJson(e))
          .toList();

      // Update cache
      _cachedCategories = parentCategories;
      _lastFetchTime = DateTime.now();
      _lastLanguage = language;

      return Right(parentCategories);
    } catch (e) {
      return Left("Error fetching categories horizontal bar".tr());
    }
  }

  // Force refresh - clears cache and fetches new data
  Future<Either<String, List<ParentCategory>>> forceRefresh(
    String language,
  ) async {
    clearCache();
    return await fetchCategoriesHorizontalBar(language);
  }

  // Clear cache manually
  void clearCache() {
    _cachedCategories = null;
    _lastFetchTime = null;
    _lastLanguage = null;
  }
}
