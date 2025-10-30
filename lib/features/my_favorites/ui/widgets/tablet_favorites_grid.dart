import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/tablet_grid_book_opinion_card.dart';

class TabletFavoritesGrid extends StatelessWidget {
  const TabletFavoritesGrid({super.key, required this.favorites});

  final List<ArticleModel> favorites;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final article = favorites[index];
                final isBookOpinion = article.categorySlug == 'books_opinions';

                return GestureDetector(
                  onTap: () {
                    context.push(
                      Routes.detailsArticalView,
                      extra: article,
                    );
                  },
                  child: isBookOpinion
                      ? TabletGridBookOpinionCard(articleItem: article)
                      : TabletGridArticleCard(articleItem: article),
                );
              },
              childCount: favorites.length,
            ),
          ),
        ),
      ],
    );
  }
}
