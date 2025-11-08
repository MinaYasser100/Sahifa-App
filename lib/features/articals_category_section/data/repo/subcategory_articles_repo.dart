import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class SubcategoryArticlesRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesDrawerSubcategory({
    required String categorySlug,
    required String language,
    required int pageNumber,
  });
  bool get hasValidCache;
  void clearCache();
  Future<Either<String, ArticlesCategoryModel>> forceRefresh({
    required String categorySlug,
    required String language,
  });
}

class SubcategoryArticlesRepoImpl implements SubcategoryArticlesRepo {
  // Singleton Pattern
  static final SubcategoryArticlesRepoImpl _instance =
      SubcategoryArticlesRepoImpl._internal(DioHelper());
  factory SubcategoryArticlesRepoImpl() => _instance;
  SubcategoryArticlesRepoImpl._internal(this._dioHelper);

  final DioHelper _dioHelper;

  // Memory Cache
  ArticlesCategoryModel? _cachedArticles;
  DateTime? _lastFetchTime;
  String? _lastCategorySlug;
  String? _lastLanguage;
  final Duration _cacheDuration = const Duration(minutes: 30);

  @override
  bool get hasValidCache =>
      _cachedArticles != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesDrawerSubcategory({
    required String categorySlug,
    required String language,
    required int pageNumber,
  }) async {
    try {
      // Check if category or language changed - invalidate cache
      if (_lastCategorySlug != categorySlug || _lastLanguage != language) {
        clearCache();
        _lastCategorySlug = categorySlug;
        _lastLanguage = language;
      }

      // Check cache only for page 1
      if (pageNumber == 1 &&
          _cachedArticles != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        return Right(_cachedArticles!);
      }
      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.pageNumber: pageNumber,
          ApiQueryParams.pageSize: 30,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.categorySlug: categorySlug,
        },
      );

      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);

      // Cache only page 1
      if (pageNumber == 1) {
        _cachedArticles = articlesCategoryModel;
        _lastFetchTime = DateTime.now();
      }

      return Right(articlesCategoryModel);
    } catch (e) {
      return Left("error_fetching_category_articles".tr());
    }
  }

  // Clear cache
  @override
  void clearCache() {
    _cachedArticles = null;
    _lastFetchTime = null;
    _lastCategorySlug = null;
    _lastLanguage = null;
  }

  // Force refresh
  @override
  Future<Either<String, ArticlesCategoryModel>> forceRefresh({
    required String categorySlug,
    required String language,
  }) async {
    clearCache();
    return getArticlesDrawerSubcategory(
      categorySlug: categorySlug,
      language: language,
      pageNumber: 1,
    );
  }
}
