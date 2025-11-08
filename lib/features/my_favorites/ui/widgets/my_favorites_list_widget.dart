import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';

class MyFavoritesListWidget extends StatelessWidget {
  const MyFavoritesListWidget({super.key, required this.favorites});

  final List<ArticleModel> favorites;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  height: 325,
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        Routes.detailsArticalView,
                        extra: favorites[index],
                      );
                    },
                    child: CustomArticleItemCard(
                      articleItem: favorites[index],
                      cardWidth: double.infinity,
                      isItemList: true,
                    ),
                  ),
                ),
              );
            }, childCount: favorites.length),
          ),
        ),
      ],
    );
  }
}
