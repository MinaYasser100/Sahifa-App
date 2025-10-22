import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

abstract class BannerRepo {
  Future<Either<String, List<ArticleItemModel>>> fetchBanners(String language);
}

class BannerRepoImpl implements BannerRepo {
  // Singleton Pattern
  static final BannerRepoImpl _instance = BannerRepoImpl._internal();
  factory BannerRepoImpl() => _instance;
  BannerRepoImpl._internal();
  final DioHelper _dioHelper = DioHelper();

  // Memory Cache
  List<ArticleItemModel>? _cachedBanners;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedBanners != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ArticleItemModel>>> fetchBanners(
    String language,
  ) async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedBanners != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedBanners!);
      }

      // If no cache or cache expired, fetch from API
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response - في المستقبل هيبقى API call حقيقي
      // final response = await _dioHelper.getData(
      //   url: ApiEndpoints.articles.path,
      //   query: {
      //     ApiQueryParams.pageSize: 15,
      //     ApiQueryParams.language: language,
      //     ApiQueryParams.isSlider: true,
      //   },
      // );
      // final ArticlesCategoryModel articlesCategoryModel =
      //     ArticlesCategoryModel.fromJson(response.data);

      final List<ArticleItemModel> banners = [
        ArticleItemModel(
          id: 'banner_1',
          imageUrl:
              'https://althawra-news.net/user_images/news/18-10-25-111655979.jpg',
          title: "breaking_major_economic_summit_concludes_successfully".tr(),
          description: "banner_1_description".tr(),
          categoryId: "category_economy",
          category: "category_economy".tr(),
          date: DateTime.now().subtract(const Duration(hours: 2)),
          viewerCount: 15420,
        ),
        ArticleItemModel(
          id: 'banner_2',
          imageUrl:
              'https://althawra-news.net/user_images/news/18-10-25-111655979.jpg',
          title: "technology_breakthrough_ai_revolution_in_healthcare".tr(),
          description: "banner_2_description".tr(),
          categoryId: "category_economy",
          category: "category_economy".tr(),
          date: DateTime.now().subtract(const Duration(hours: 5)),
          viewerCount: 23150,
        ),
        ArticleItemModel(
          id: 'banner_3',
          imageUrl:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          title: "climate_action_global_initiative_launches_today".tr(),
          description: "banner_3_description".tr(),
          category: "category_economy".tr(),
          categoryId: "category_economy",
          date: DateTime.now().subtract(const Duration(hours: 8)),
          viewerCount: 18900,
        ),
        ArticleItemModel(
          id: 'banner_4',
          imageUrl:
              'https://althawra-news.net/user_images/news/18-10-25-111655979.jpg',
          title: "education_reform_new_digital_learning_platform".tr(),
          description: "banner_4_description".tr(),
          categoryId: "category_economy",
          date: DateTime.now().subtract(const Duration(hours: 12)),
          category: "category_economy".tr(),
          viewerCount: 12340,
        ),
        ArticleItemModel(
          id: 'banner_5',
          imageUrl:
              'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
          title: "sports_championship_finals_set_record_viewership".tr(),
          description: "banner_5_description".tr(),
          categoryId: "category_economy",
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: "category_economy".tr(),
          viewerCount: 45780,
        ),
      ];

      // Store in cache
      _cachedBanners = banners;
      _lastFetchTime = DateTime.now();

      return Right(banners);
    } catch (e) {
      return Left("Failed to load banners".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedBanners = null;
    _lastFetchTime = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, List<ArticleItemModel>>> forceRefresh(
    String language,
  ) async {
    clearCache();
    return fetchBanners(language);
  }
}
