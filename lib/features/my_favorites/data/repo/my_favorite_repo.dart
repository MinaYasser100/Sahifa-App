import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

abstract class MyFavoriteRepo {
  Future<Either<String, List<ArticleItemModel>>> fetchFavorites();
}

class MyFavoriteRepoImpl implements MyFavoriteRepo {
  // Singleton Pattern
  static final MyFavoriteRepoImpl _instance = MyFavoriteRepoImpl._internal();
  factory MyFavoriteRepoImpl() => _instance;
  MyFavoriteRepoImpl._internal();

  // Memory Cache
  List<ArticleItemModel>? _cachedFavorites;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedFavorites != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ArticleItemModel>>> fetchFavorites() async {
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
      //     .map((json) => ArticleItemModel.fromJson(json))
      //     .toList();
      // return Right(favorites);
      final List<ArticleItemModel> favorites = [
        ArticleItemModel(
          id: 'favorite_1',
          imageUrl:
              'https://althawra-news.net/user_images/news/18-10-25-111655979.jpg',
          title: "favorite_article_technology_advances".tr(),
          description: "favorite_1_description".tr(),
          categoryId: "category_technology",
          category: "category_technology".tr(),
          date: DateTime.now().subtract(const Duration(days: 1)),
          viewerCount: 12500,
        ),
        ArticleItemModel(
          id: 'favorite_2',
          imageUrl:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          title: "favorite_article_sports_championship".tr(),
          description: "favorite_2_description".tr(),
          categoryId: "category_sports",
          category: "category_sports".tr(),
          date: DateTime.now().subtract(const Duration(days: 2)),
          viewerCount: 18900,
        ),
        ArticleItemModel(
          id: 'favorite_3',
          imageUrl:
              'https://althawra-news.net/user_images/news/18-10-25-111655979.jpg',
          title: "favorite_article_health_breakthrough".tr(),
          description: "favorite_3_description".tr(),
          categoryId: "category_health",
          category: "category_health".tr(),
          date: DateTime.now().subtract(const Duration(days: 3)),
          viewerCount: 15200,
        ),
        ArticleItemModel(
          id: 'favorite_4',
          imageUrl:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          title: "favorite_article_economy_update".tr(),
          description: "favorite_4_description".tr(),
          categoryId: "category_economy",
          category: "category_economy".tr(),
          date: DateTime.now().subtract(const Duration(days: 4)),
          viewerCount: 22100,
        ),
        ArticleItemModel(
          id: 'favorite_5',
          imageUrl:
              'https://althawra-news.net/user_images/news/18-10-25-111655979.jpg',
          title: "favorite_article_education_reform".tr(),
          description: "favorite_5_description".tr(),
          categoryId: "category_education",
          category: "category_education".tr(),
          date: DateTime.now().subtract(const Duration(days: 5)),
          viewerCount: 9800,
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
  Future<Either<String, List<ArticleItemModel>>> forceRefresh() async {
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
