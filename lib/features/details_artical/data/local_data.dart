import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

final List<ArticleItemModel> trendingArticles = [
  ArticleItemModel(
    id: '1',
    imageUrl:
        'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
    title: 'trending_article_1_title'.tr(),
    description: 'trending_article_1_description'.tr(),
    date: DateTime(2025, 10, 13),
    category: 'category_economy'.tr(),
    categoryId: 'category_economy',
    viewerCount: 45200,
  ),
  ArticleItemModel(
    id: '2',
    imageUrl:
        'https://althawra-news.net/user_images/news/16-10-25-871520849.jpg',
    title: 'trending_article_2_title'.tr(),
    category: 'category_economy'.tr(),
    categoryId: 'category_economy',
    description: 'trending_article_2_description'.tr(),
    date: DateTime(2025, 10, 13),
    viewerCount: 38900,
  ),
  ArticleItemModel(
    id: '3',
    imageUrl:
        'https://althawra-news.net/user_images/news/16-10-25-787182266.jpg',
    title: 'trending_article_3_title'.tr(),
    description: 'trending_article_3_description'.tr(),
    category: 'category_economy'.tr(),
    categoryId: 'category_economy',
    date: DateTime(2025, 10, 12),
    viewerCount: 32500,
  ),
  ArticleItemModel(
    id: '4',
    imageUrl:
        'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
    title: 'trending_article_4_title'.tr(),
    category: 'category_economy'.tr(),
    categoryId: 'category_economy',
    description: 'trending_article_4_description'.tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 28700,
  ),
  ArticleItemModel(
    id: '5',
    imageUrl:
        'https://althawra-news.net/user_images/news/16-10-25-787182266.jpg',
    title: 'trending_article_5_title'.tr(),
    category: 'category_economy'.tr(),
    categoryId: 'category_economy',
    description: 'trending_article_5_description'.tr(),
    date: DateTime(2025, 10, 11),
    viewerCount: 25400,
  ),
];
