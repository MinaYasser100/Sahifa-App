import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';

class MobileGalleriesList extends StatelessWidget {
  const MobileGalleriesList({
    super.key,
    required this.articles,
    required this.scrollController,
  });

  final List articles;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                context.push(Routes.detailsGalleryView, extra: articles[index]);
              },
              child: CustomArticleItemCard(
                articleItem: articles[index],
                cardWidth: double.infinity,
                isItemList: true,
              ),
            ),
          );
        }, childCount: articles.length),
      ),
    );
  }
}
