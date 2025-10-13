import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/features/home/ui/widgets/artical_item_content.dart';
import 'package:sahifa/features/home/ui/widgets/artical_item_image.dart';

class ArticalItemCard extends StatelessWidget {
  const ArticalItemCard({super.key, required this.articleItem});

  final ArticalItemModel articleItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12, bottom: 10),
      decoration: BoxDecoration(
        color: ColorsTheme().whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorsTheme().blackColor.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          ArticalItemImage(imageUrl: articleItem.imageUrl),

          // Content Section
          ArticalItemContent(articalItem: articleItem),
        ],
      ),
    );
  }
}
