import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

abstract class BannerRepo {
  Future<Either<String, List<ArticleItemModel>>> fetchBanners();
}

class BannerRepoImpl implements BannerRepo {
  @override
  Future<Either<String, List<ArticleItemModel>>> fetchBanners() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response - في المستقبل هيبقى API call حقيقي
      // في BannerRepoImpl.fetchBanners()
      // final response = await _apiService.get('/banners');
      // final banners = (response.data as List)
      //     .map((json) => ArticleItemModel.fromJson(json))
      //     .toList();
      // return Right(banners);
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

      return Right(banners);
    } catch (e) {
      return Left("Failed to load banners".tr());
    }
  }
}
