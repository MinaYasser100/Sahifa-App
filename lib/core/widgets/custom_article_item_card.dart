import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_image.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/core/widgets/custom_article_item_content.dart';

class CustomArticleItemCard extends StatelessWidget {
  const CustomArticleItemCard({
    super.key,
    required this.articleItem,
    this.cardWidth = 240,
    this.isItemList = false,
  });

  final ArticalItemModel articleItem;
  final double cardWidth;
  final bool isItemList;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: isItemList ? 0 : 12, bottom: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsTheme().cardColor : ColorsTheme().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? ColorsTheme().blackColor.withValues(alpha: 0.3)
                : ColorsTheme().blackColor.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          CustomArticleImage(imageUrl: articleItem.imageUrl, height: 140),
          // Content Section
          CustomArticleItemContent(articleItem: articleItem),
        ],
      ),
    );
  }
}
