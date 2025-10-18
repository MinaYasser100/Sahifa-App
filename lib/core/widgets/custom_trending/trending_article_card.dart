import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_image.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

import 'custom_index_badge.dart';
import 'trend_card_content.dart';

class TrendingArticleCard extends StatelessWidget {
  const TrendingArticleCard({
    super.key,
    required this.articleItem,
    required this.index,
  });

  final ArticleItemModel articleItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeInLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorsTheme().primaryDark
              : ColorsTheme().whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: FadeInLeft(
          child: Row(
            children: [
              // Image Section with Index Badge
              Stack(
                children: [
                  CustomArticleImage(
                    imageUrl: articleItem.imageUrl,
                    height: 120,
                    width: 120,
                    changeBorderRadius: false,
                  ),
                  // Index Badge
                  CustomIndexBadge(index: index),
                ],
              ),

              // Content Section
              TrendCardContent(articleItem: articleItem),
            ],
          ),
        ),
      ),
    );
  }
}
