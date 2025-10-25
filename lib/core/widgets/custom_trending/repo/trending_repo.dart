import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class TrendingRepo {
  Future<Either<String, List<ArticleModel>>> fetchTrendingArticles(
    String language,
  );
}

class TrendingRepoImpl implements TrendingRepo {
  // Singleton Pattern
  static final TrendingRepoImpl _instance = TrendingRepoImpl._internal(
    DioHelper(),
  );
  factory TrendingRepoImpl() => _instance;
  TrendingRepoImpl._internal(this._dioHelper);
  final DioHelper _dioHelper;
  // Memory Cache
  List<ArticleModel>? _cachedTrendingArticles;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getter for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedTrendingArticles != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ArticleModel>>> fetchTrendingArticles(
    String language,
  ) async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedTrendingArticles != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedTrendingArticles!);
      }

      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.isFeatured: true,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);

      // Store in cache
      _cachedTrendingArticles = articlesCategoryModel.articles ?? [];
      _lastFetchTime = DateTime.now();

      return Right(_cachedTrendingArticles!);
    } catch (e) {
      return Left("failed_to_load_trending_articles".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedTrendingArticles = null;
    _lastFetchTime = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, List<ArticleModel>>> forceRefresh(
    String language,
  ) async {
    clearCache();
    return fetchTrendingArticles(language);
  }
}
