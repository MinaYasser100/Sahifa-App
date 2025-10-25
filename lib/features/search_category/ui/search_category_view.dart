import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';

class SearchCategoryView extends StatelessWidget {
  const SearchCategoryView({super.key, required this.category});
  final CategoryFilterModel category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name), elevation: 0),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        context.push(
                          Routes.detailsArticalView,
                          extra: category.id == 'books_opinions'
                              ? booksOpinionsListItems[index]
                              : trendingArticles[index],
                        );
                      },
                      child: (category.id == 'books_opinions')
                          ? CustomBooksOpinionsItem(
                              articleItem: booksOpinionsListItems[index],
                              cardWidth: double.infinity,
                              isItemList: true,
                            )
                          : CustomArticleItemCard(
                              articleItem: trendingArticles[index],
                              cardWidth: double.infinity,
                              isItemList: true,
                            ),
                    ),
                  );
                },
                childCount: (category.id == 'books_opinions')
                    ? booksOpinionsListItems.length
                    : trendingArticles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<ArticleModel> booksOpinionsListItems = [
  ArticleModel(
    authorId: 'jkdkjjkhfkj',
    authorName: "Author Name",
    categoryName: "category_economy".tr(),
    createdAt: "2025-10-13T12:34:56",
    id: '1',
    image: 'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
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
    summary: "trending_article_1_description".tr(),
    updatedAt: "2025-10-13T12:34:56",
    categoryId: 'category_economy',
    viewsCount: 50000,
  ),
  ArticleModel(
    authorId: 'jkdkjjkhfkj',
    authorName: "Author Name",
    categoryName: "category_economy".tr(),
    createdAt: "2025-10-13T12:34:56",
    id: '1',
    image: 'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
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
    summary: "trending_article_1_description".tr(),
    updatedAt: "2025-10-13T12:34:56",
    categoryId: 'category_economy',
    viewsCount: 50000,
  ),
  ArticleModel(
    authorId: 'jkdkjjkhfkj',
    authorName: "Author Name",
    categoryName: "category_economy".tr(),
    createdAt: "2025-10-13T12:34:56",
    id: '1',
    image: 'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
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
    summary: "trending_article_1_description".tr(),
    updatedAt: "2025-10-13T12:34:56",
    categoryId: 'category_economy',
    viewsCount: 50000,
  ),
  ArticleModel(
    authorId: 'jkdkjjkhfkj',
    authorName: "Author Name",
    categoryName: "category_economy".tr(),
    createdAt: "2025-10-13T12:34:56",
    id: '1',
    image: 'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
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
    summary: "trending_article_1_description".tr(),
    updatedAt: "2025-10-13T12:34:56",
    categoryId: 'category_economy',
    viewsCount: 50000,
  ),
  ArticleModel(
    authorId: 'jkdkjjkhfkj',
    authorName: "Author Name",
    categoryName: "category_economy".tr(),
    createdAt: "2025-10-13T12:34:56",
    id: '1',
    image: 'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
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
    summary: "trending_article_1_description".tr(),
    updatedAt: "2025-10-13T12:34:56",
    categoryId: 'category_economy',
    viewsCount: 50000,
  ),
];
