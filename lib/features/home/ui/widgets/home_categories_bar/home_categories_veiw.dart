import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';
import 'package:sahifa/features/search_category/ui/search_category_view.dart';

class HomeCategoriesView extends StatelessWidget {
  const HomeCategoriesView({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                        extra: categorySlug == 'books_opinions'
                            ? booksOpinionsListItems[index]
                            : trendingArticles[index],
                      );
                    },
                    child: (categorySlug == 'books_opinions')
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
              childCount: (categorySlug == 'books_opinions')
                  ? booksOpinionsListItems.length
                  : trendingArticles.length,
            ),
          ),
        ),
      ],
    );
  }
}
