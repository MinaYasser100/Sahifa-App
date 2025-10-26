import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesSearchCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> fetchArticleSearchCategory(
    String categorySlug,
    String language, {
    int page = 1,
  });
  void clearCache();
  void refresh();
}

class ArticlesSearchCategoryRepoImpl implements ArticlesSearchCategoryRepo {
  // Singleton Pattern
  static final ArticlesSearchCategoryRepoImpl _instance =
      ArticlesSearchCategoryRepoImpl._internal();
  factory ArticlesSearchCategoryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  ArticlesSearchCategoryRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache - Map by categorySlug and language
  final Map<String, ArticlesCategoryModel> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Generate cache key
  String _getCacheKey(String categorySlug, String language, int page) {
    return '${categorySlug}_${language}_page$page';
  }

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
  Future<Either<String, ArticlesCategoryModel>> fetchArticleSearchCategory(
    String categorySlug,
    String language, {
    int page = 1,
  }) async {
    try {
      final cacheKey = _getCacheKey(categorySlug, language, page);

      // Check cache first
      if (_isCacheValid(cacheKey)) {
        return Right(_cache[cacheKey]!);
      }

      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.categorySlug: categorySlug,
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.pageNumber: page,
          ApiQueryParams.language: backendLanguage,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);

      // Update cache
      _cache[cacheKey] = articlesCategoryModel;
      _cacheTimestamps[cacheKey] = DateTime.now();

      return Right(articlesCategoryModel);
    } catch (e) {
      return Left('Error fetching articles of this category'.tr());
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
