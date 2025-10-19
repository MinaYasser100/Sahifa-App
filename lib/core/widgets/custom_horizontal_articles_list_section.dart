import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/core/widgets/custom_article_item_card.dart';
import 'package:sahifa/features/details_artical/data/local_data.dart';

class CustomHorizontalArticlesListSection extends StatelessWidget {
  const CustomHorizontalArticlesListSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArticleItemModel> articlesItems = trendingArticles;

    return SizedBox(
      height: 325,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: articlesItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push(
                Routes.detailsArticalView,
                extra: articlesItems[index],
              );
            },
            child: FadeInLeft(
              child: CustomArticleItemCard(articleItem: articlesItems[index]),
            ),
          );
        },
      ),
    );
  }
}
