import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_content.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_index_badge.dart';

class TabletTrendingArticleCard extends StatelessWidget {
  const TabletTrendingArticleCard({
    super.key,
    required this.articleItem,
    required this.index,
  });

  final ArticleModel articleItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      delay: Duration(milliseconds: index * 50),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorsTheme().primaryDark
              : ColorsTheme().whiteColor,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                CustomImageWidget(
                  imageUrl: articleItem.image ?? '',
                  height: 250,
                ),
                // Content Section
                CustomArticleItemContent(articleItem: articleItem),
              ],
            ),
            // Index Badge instead of Heart Icon
            Positioned(
              top: 8,
              right: 8,
              child: TabletCardIndexBadge(index: index),
            ),
          ],
        ),
      ),
    );
  }
}
