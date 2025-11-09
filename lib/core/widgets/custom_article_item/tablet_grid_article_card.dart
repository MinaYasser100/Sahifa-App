import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/like_post/ui/like_button_widget.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_content.dart';

/// Widget specifically designed for tablet grid layout
class TabletGridArticleCard extends StatelessWidget {
  const TabletGridArticleCard({super.key, required this.articleItem});

  final ArticleModel articleItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeInLeft(
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
                Expanded(
                  flex: 2,
                  child: CustomImageWidget(
                    imageUrl: articleItem.image ?? '',
                    height: double.infinity,
                  ),
                ),
                // Content Section
                Expanded(
                  flex: 1,
                  child: CustomArticleItemContent(articleItem: articleItem),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: LikeButtonWidget(article: articleItem),
            ),
          ],
        ),
      ),
    );
  }
}
