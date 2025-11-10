import 'package:flutter/material.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_category_badge.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_title.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_metadata.dart';

class TabletCardContentSection extends StatelessWidget {
  const TabletCardContentSection({super.key, required this.articleItem});

  final ArticleModel articleItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (articleItem.categoryName != null)
                  TabletCardCategoryBadge(
                    categoryName: articleItem.categoryName ?? '',
                  ),
                const SizedBox(height: 8),
                TabletCardTitle(title: articleItem.title ?? ''),
              ],
            ),
            const SizedBox(height: 8),
            TabletCardMetadata(articleItem: articleItem),
          ],
        ),
      ),
    );
  }
}
