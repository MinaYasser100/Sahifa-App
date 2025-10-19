import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

abstract class TrendingRepo {
  Future<Either<String, List<ArticleItemModel>>> fetchTrendingArticles();
}

class TrendingRepoImpl implements TrendingRepo {
  // Singleton Pattern
  static final TrendingRepoImpl _instance = TrendingRepoImpl._internal();
  factory TrendingRepoImpl() => _instance;
  TrendingRepoImpl._internal();

  // Memory Cache
  List<ArticleItemModel>? _cachedTrendingArticles;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getter for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedTrendingArticles != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ArticleItemModel>>> fetchTrendingArticles() async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedTrendingArticles != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedTrendingArticles!);
      }

      // If no cache or cache expired, fetch from API
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response - في المستقبل هيبقى API call حقيقي
      // final response = await _apiService.get('/trending-articles');
      // final articles = (response.data as List)
      //     .map((json) => ArticleItemModel.fromJson(json))
      //     .toList();
      // return Right(articles);

      final List<ArticleItemModel> trendingArticles = [
        ArticleItemModel(
          id: '1',
          imageUrl:
              "https://althawra-news.net/user_images/news/18-10-25-111655979.jpg",
          title: "trending_article_1_title".tr(),
          category: "category_politics".tr(),
          categoryId: "category_politics",
          description: "trending_article_1_description".tr(),
          date: DateTime(2025, 10, 18),
          viewerCount: 1250,
        ),
        ArticleItemModel(
          id: '2',
          imageUrl:
              "https://althawra-news.net/user_images/news/18-10-25-111655979.jpg",
          title: "trending_article_2_title".tr(),
          category: "category_sports".tr(),
          categoryId: "category_sports",
          description: "trending_article_2_description".tr(),
          date: DateTime(2025, 10, 17),
          viewerCount: 980,
        ),
        ArticleItemModel(
          id: '3',
          imageUrl:
              "https://althawra-news.net/user_images/news/26-08-25-179659767.jpg",
          title: "trending_article_3_title".tr(),
          category: "category_technology".tr(),
          categoryId: "category_technology",
          description: "trending_article_3_description".tr(),
          date: DateTime(2025, 10, 16),
          viewerCount: 1560,
        ),
        ArticleItemModel(
          id: '4',
          imageUrl:
              "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
          title: "trending_article_4_title".tr(),
          category: "category_economy".tr(),
          categoryId: "category_economy",
          description: "trending_article_4_description".tr(),
          date: DateTime(2025, 10, 15),
          viewerCount: 850,
        ),
        ArticleItemModel(
          id: '5',
          imageUrl:
              "https://althawra-news.net/user_images/news/18-10-25-111655979.jpg",
          title: "trending_article_5_title".tr(),
          category: "category_health".tr(),
          categoryId: "category_health",
          description: "trending_article_5_description".tr(),
          date: DateTime(2025, 10, 14),
          viewerCount: 720,
        ),
      ];

      // Store in cache
      _cachedTrendingArticles = trendingArticles;
      _lastFetchTime = DateTime.now();

      return Right(trendingArticles);
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
  Future<Either<String, List<ArticleItemModel>>> forceRefresh() async {
    clearCache();
    return fetchTrendingArticles();
  }
}
