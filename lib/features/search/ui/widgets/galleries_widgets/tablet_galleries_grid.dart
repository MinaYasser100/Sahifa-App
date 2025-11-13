import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';

class TabletGalleriesGrid extends StatelessWidget {
  const TabletGalleriesGrid({
    super.key,
    required this.articles,
    required this.scrollController,
  });

  final List articles;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return GestureDetector(
            onTap: () {
              context.push(Routes.detailsGalleryView, extra: articles[index]);
            },
            child: TabletGridArticleCard(articleItem: articles[index]),
          );
        }, childCount: articles.length),
      ),
    );
  }
}
