import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';

abstract class MyFavoriteRepo {
  Future<Either<String, List<ArticleModel>>> fetchFavorites();
}

class MyFavoriteRepoImpl implements MyFavoriteRepo {
  // Singleton Pattern
  static final MyFavoriteRepoImpl _instance = MyFavoriteRepoImpl._internal();
  factory MyFavoriteRepoImpl() => _instance;
  MyFavoriteRepoImpl._internal();

  // Memory Cache
  List<ArticleModel>? _cachedFavorites;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedFavorites != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ArticleModel>>> fetchFavorites() async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedFavorites != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedFavorites!);
      }

      // If no cache or cache expired, fetch from API
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response - في المستقبل هيبقى API call حقيقي
      // في MyFavoriteRepoImpl.fetchFavorites()
      // final response = await _apiService.get('/favorites');
      // final favorites = (response.data as List)
      //     .map((json) => ArticleModel.fromJson(json))
      //     .toList();
      // return Right(favorites);
      final List<ArticleModel> favorites = [
        ArticleModel(
          authorName: "Author Name",
          categoryName: "category_economy".tr(),
          createdAt: "2025-10-13T12:34:56",
          id: '1',
          image:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          imageDescription: "Description of trending article 1",
          isBreaking: false,
          isFeatured: true,
          isRecommended: false,
          isSlider: false,
          title: 'trending_article_1_title'.tr(),
          language: "ar",
          likesCount: 361125,
          publishedAt: "2025-10-13T12:34:56",
          slug: "category_economy".tr(),
          status: "published",
          description: "trending_article_1_description".tr(),
          categoryId: 'category_economy',
          viewsCount: 50000,
        ),
        ArticleModel(
          authorName: "Author Name",
          categoryName: "category_economy".tr(),
          createdAt: "2025-10-13T12:34:56",
          id: '1',
          image:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          imageDescription: "Description of trending article 1",
          isBreaking: false,
          isFeatured: true,
          isRecommended: false,
          isSlider: false,
          title: 'trending_article_1_title'.tr(),
          language: "ar",
          likesCount: 361125,
          publishedAt: "2025-10-13T12:34:56",
          slug: "category_economy".tr(),
          status: "published",
          description: "trending_article_1_description".tr(),
          categoryId: 'category_economy',
          viewsCount: 50000,
        ),
        ArticleModel(
          authorName: "Author Name",
          categoryName: "category_economy".tr(),
          createdAt: "2025-10-13T12:34:56",
          id: '1',
          image:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          imageDescription: "Description of trending article 1",
          isBreaking: false,
          isFeatured: true,
          isRecommended: false,
          isSlider: false,
          title: 'trending_article_1_title'.tr(),
          language: "ar",
          likesCount: 361125,
          publishedAt: "2025-10-13T12:34:56",
          slug: "category_economy".tr(),
          status: "published",
          description: "trending_article_1_description".tr(),
          categoryId: 'category_economy',
          viewsCount: 50000,
        ),
        ArticleModel(
          authorName: "Author Name",
          categoryName: "category_economy".tr(),
          createdAt: "2025-10-13T12:34:56",
          id: '1',
          image:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          imageDescription: "Description of trending article 1",
          isBreaking: false,
          isFeatured: true,
          isRecommended: false,
          isSlider: false,
          title: 'trending_article_1_title'.tr(),
          language: "ar",
          likesCount: 361125,
          publishedAt: "2025-10-13T12:34:56",
          slug: "category_economy".tr(),
          status: "published",
          description: "trending_article_1_description".tr(),
          categoryId: 'category_economy',
          viewsCount: 50000,
        ),
      ];

      // Store in cache
      _cachedFavorites = favorites;
      _lastFetchTime = DateTime.now();
      return Right(favorites);
    } catch (e) {
      return Left("failed_to_load_favorites".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedFavorites = null;
    _lastFetchTime = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, List<ArticleModel>>> forceRefresh() async {
    clearCache();
    return fetchFavorites();
  }

  // Method to remove favorite (for future implementation)
  Future<Either<String, bool>> removeFavorite(String articleId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      // في المستقبل هيبقى API call حقيقي
      // final response = await _apiService.delete('/favorites/$articleId');

      // Clear cache to force refresh on next fetch
      clearCache();

      return const Right(true);
    } catch (e) {
      return Left("failed_to_remove_favorite".tr());
    }
  }
}
