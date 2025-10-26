import 'package:dartz/dartz.dart';
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
  HorizontalBarSubcategoriesRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache - Map by parentCategorySlug
  final Map<String, List<SubcategoryInfoModel>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Check if cache is valid
  bool _isCacheValid(String cacheKey) {
    if (!_cache.containsKey(cacheKey) ||
        !_cacheTimestamps.containsKey(cacheKey)) {
      return false;
    }
    final timestamp = _cacheTimestamps[cacheKey]!;
    return DateTime.now().difference(timestamp) < _cacheDuration;
  }

  @override
  Future<Either<String, List<SubcategoryInfoModel>>>
  getSubcategoriesByParentCategory({required String parentCategorySlug}) async {
    try {
      // Check cache first
      if (_isCacheValid(parentCategorySlug)) {
        return Right(_cache[parentCategorySlug]!);
      }

      final response = await _dioHelper.getData(
        url: ApiEndpoints.categoryInfoBySlug.withParams({
          'slug': parentCategorySlug,
        }),
        query: {ApiQueryParams.withSub: true},
      );
      final ParentCategory parentCategory = ParentCategory.fromJson(
        response.data,
      );
      final subcategories = parentCategory.subcategories ?? [];

      // Update cache
      _cache[parentCategorySlug] = subcategories;
      _cacheTimestamps[parentCategorySlug] = DateTime.now();

      return Right(subcategories);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  @override
  void refresh() {
    clearCache();
  }
}
