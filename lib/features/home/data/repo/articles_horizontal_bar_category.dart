import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesHorizontalBarCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory({
    required String categorySlug,
    required String language,
    required int pageNumber,
  });
}

class ArticlesHorizontalBarCategoryRepoImpl
    implements ArticlesHorizontalBarCategoryRepo {
  final DioHelper _dioHelper;

  // Singleton instance
  static final ArticlesHorizontalBarCategoryRepoImpl _instance =
      ArticlesHorizontalBarCategoryRepoImpl._internal(DioHelper());

  factory ArticlesHorizontalBarCategoryRepoImpl(DioHelper dioHelper) {
    return _instance;
  }

  ArticlesHorizontalBarCategoryRepoImpl._internal(this._dioHelper);

  // Cache storage per page with category as key
  final Map<String, Map<int, List<ArticleModel>>> _cachedArticlesByCategory =
      {};
  final Map<String, DateTime?> _cacheTimeByCategory = {};
  final Map<String, String?> _cachedLanguageByCategory = {};

  // Cache duration
  static const Duration _cacheDuration = Duration(minutes: 30);

  // Check if cache is valid for specific page
  bool hasValidCache(String categorySlug, int pageNumber) {
    final cacheTime = _cacheTimeByCategory[categorySlug];
    final cachedLanguage = _cachedLanguageByCategory[categorySlug];

    if (cacheTime == null || cachedLanguage == null) return false;

    final isExpired = DateTime.now().difference(cacheTime) > _cacheDuration;
    final pageCache = _cachedArticlesByCategory[categorySlug]?[pageNumber];

    return !isExpired && pageCache != null && pageCache.isNotEmpty;
  }

  @override
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory({
    required String categorySlug,
    required String language,
    required int pageNumber,
  }) async {
    // Check if language changed, clear cache for this category
    if (_cachedLanguageByCategory[categorySlug] != null &&
        _cachedLanguageByCategory[categorySlug] != language) {
      _cachedArticlesByCategory[categorySlug]?.clear();
      _cacheTimeByCategory[categorySlug] = null;
    }

    // Return cached data if valid
    if (hasValidCache(categorySlug, pageNumber)) {
      final cachedArticles =
          _cachedArticlesByCategory[categorySlug]![pageNumber]!;
      // Return with limited pagination info from cache
      return Right(
        ArticlesCategoryModel(
          articles: cachedArticles,
          pageNumber: pageNumber,
          pageSize: 20,
        ),
      );
    }

    try {
      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.categorySlug: categorySlug,
          ApiQueryParams.pageSize: 30,
          ApiQueryParams.pageNumber: pageNumber,
          ApiQueryParams.language: backendLanguage,
        },
      );

      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);

      // Cache the articles for this page and category
      if (articlesCategoryModel.articles != null) {
        _cachedArticlesByCategory.putIfAbsent(categorySlug, () => {});
        _cachedArticlesByCategory[categorySlug]![pageNumber] =
            articlesCategoryModel.articles!;
        _cacheTimeByCategory[categorySlug] = DateTime.now();
        _cachedLanguageByCategory[categorySlug] = language;
      }

      return Right(articlesCategoryModel);
    } catch (e) {
      return Left('Error fetching articles: ${e.toString()}');
    }
  }

  // Force refresh - clears cache for specific category
  void clearCache(String categorySlug) {
    _cachedArticlesByCategory[categorySlug]?.clear();
    _cacheTimeByCategory[categorySlug] = null;
    _cachedLanguageByCategory[categorySlug] = null;
  }
}
