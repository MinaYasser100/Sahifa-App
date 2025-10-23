import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
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

List<ArticleItemModel> booksOpinionsListItems = [
  ArticleItemModel(
    id: '4',
    imageUrl: "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
    title: "trending_article_4_title".tr(),
    category: "books_opinions".tr(),
    categoryId: "books_opinions".tr(),
    description: "trending_article_4_description".tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 250,
  ),
  ArticleItemModel(
    id: '4',
    imageUrl: "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
    title: "trending_article_4_title".tr(),
    category: "books_opinions".tr(),
    categoryId: "books_opinions".tr(),
    description: "trending_article_4_description".tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 250,
  ),
  ArticleItemModel(
    id: '4',
    imageUrl: "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
    title: "trending_article_4_title".tr(),
    category: "books_opinions".tr(),
    categoryId: "books_opinions".tr(),
    description: "trending_article_4_description".tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 250,
  ),
  ArticleItemModel(
    id: '4',
    imageUrl: "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
    title: "trending_article_4_title".tr(),
    category: "books_opinions".tr(),
    categoryId: "books_opinions".tr(),
    description: "trending_article_4_description".tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 250,
  ),
  ArticleItemModel(
    id: '4',
    imageUrl: "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
    title: "trending_article_4_title".tr(),
    category: "books_opinions".tr(),
    categoryId: "books_opinions".tr(),
    description: "trending_article_4_description".tr(),
    date: DateTime(2025, 10, 12),
    viewerCount: 250,
  ),
];
