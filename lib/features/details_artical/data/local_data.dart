import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

final List<ArticleItemModel> trendingArticles = [
  ArticleItemModel(
    id: '1',
    imageUrl:
        'https://images.unsplash.com/photo-1495020689067-958852a7765e?w=400',
    title: 'trending_article_1_title'.tr(),
    description: 'trending_article_1_description'.tr(),
    date: DateTime(2025, 10, 13),
    viewerCount: 45200,
  ),
  ArticleItemModel(
    id: '2',
    imageUrl:
        'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37?w=400',
    title: 'trending_article_2_title'.tr(),
    description: 'trending_article_2_description'.tr(),
    date: DateTime(2025, 10, 13),
    viewerCount: 38900,
  ),
  ArticleItemModel(
    id: '3',
    imageUrl:
        'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=400',
    title: 'trending_article_3_title'.tr(),
    description: 'trending_article_3_description'.tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 32500,
  ),
  ArticleItemModel(
    id: '4',
    imageUrl:
        'https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?w=400',
    title: 'trending_article_4_title'.tr(),
    description: 'trending_article_4_description'.tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 28700,
  ),
  ArticleItemModel(
    id: '5',
    imageUrl:
        'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=400',
    title: 'trending_article_5_title'.tr(),
    description: 'trending_article_5_description'.tr(),
    date: DateTime(2025, 10, 11),
    viewerCount: 25400,
  ),
];
