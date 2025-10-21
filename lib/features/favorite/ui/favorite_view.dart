import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item_card.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('my_favorites'.tr())),
      body: CustomScrollView(
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
                          extra: trendingArticles[index],
                        );
                      },
                      child: CustomArticleItemCard(
                        articleItem: trendingArticles[index],
                        cardWidth: double.infinity,
                        isItemList: true,
                      ),
                    ),
                  ),
                );
              }, childCount: trendingArticles.length),
            ),
          ),
        ],
      ),
    );
  }
}
