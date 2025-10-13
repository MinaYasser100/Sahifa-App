import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_image.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

import 'custom_index_badge.dart';
import 'trend_card_content.dart';

class TrendingArticleCard extends StatelessWidget {
  const TrendingArticleCard({
    super.key,
    required this.articleItem,
    required this.index,
  });

  final ArticalItemModel articleItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorsTheme().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorsTheme().primaryDark.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Section with Index Badge
          Stack(
            children: [
              CustomArticleImage(
                imageUrl: articleItem.imageUrl,
                height: 120,
                width: 120,
                changeBorderRadius: true,
              ),
              // Index Badge
              CustomIndexBadge(index: index),
            ],
          ),

          // Content Section
          TrendCardContent(articleItem: articleItem),
        ],
      ),
    );
  }
}
