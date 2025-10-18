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
              'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800&h=400&fit=crop',
          title: "breaking_major_economic_summit_concludes_successfully".tr(),
          description: "banner_1_description".tr(),
          date: DateTime.now().subtract(const Duration(hours: 2)),
          viewerCount: 15420,
        ),
        ArticleItemModel(
          id: 'banner_2',
          imageUrl:
              'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=800&h=400&fit=crop',
          title: "technology_breakthrough_ai_revolution_in_healthcare".tr(),
          description: "banner_2_description".tr(),
          date: DateTime.now().subtract(const Duration(hours: 5)),
          viewerCount: 23150,
        ),
        ArticleItemModel(
          id: 'banner_3',
          imageUrl:
              'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&h=400&fit=crop',
          title: "climate_action_global_initiative_launches_today".tr(),
          description: "banner_3_description".tr(),
          date: DateTime.now().subtract(const Duration(hours: 8)),
          viewerCount: 18900,
        ),
        ArticleItemModel(
          id: 'banner_4',
          imageUrl:
              'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=800&h=400&fit=crop',
          title: "education_reform_new_digital_learning_platform".tr(),
          description: "banner_4_description".tr(),
          date: DateTime.now().subtract(const Duration(hours: 12)),
          viewerCount: 12340,
        ),
        ArticleItemModel(
          id: 'banner_5',
          imageUrl:
              'https://images.unsplash.com/photo-1461532257246-777de18cd58b?w=800&h=400&fit=crop',
          title: "sports_championship_finals_set_record_viewership".tr(),
          description: "banner_5_description".tr(),
          date: DateTime.now().subtract(const Duration(days: 1)),
          viewerCount: 45780,
        ),
      ];

      return Right(banners);
    } catch (e) {
      return Left("Failed to load banners".tr());
    }
  }
}
