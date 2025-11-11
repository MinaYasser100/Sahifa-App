import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/like_post/ui/like_button_widget.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_books_opinions_article_content.dart';

import 'custom_book_opinion_image.dart';

class CustomBooksOpinionsItem extends StatelessWidget {
  const CustomBooksOpinionsItem({
    super.key,
    required this.articleItem,
    this.cardWidth = 280,
    this.isItemList = false,
  });

  final ArticleModel articleItem;
  final double cardWidth;
  final bool isItemList;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isTablet = ResponsiveHelper.isTablet(context);

    return FadeInLeft(
      child: Container(
        width: isTablet
            ? 320
            : (cardWidth == double.infinity ? null : cardWidth),
        height: isTablet ? 380 : 330,
        margin: EdgeInsets.only(left: isItemList ? 0 : 12, bottom: 10),
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
                GestureDetector(
                  onTap: () {
                    context.push(Routes.detailsArticalView, extra: articleItem);
                  },
                  child: CustomBookOpinionImage(
                    imageUrl: articleItem.authorImage ?? '',
                    authorName: articleItem.authorName ?? '',
                    containerWidth: cardWidth == double.infinity
                        ? double.infinity
                        : cardWidth,
                  ),
                ),
                const SizedBox(height: 15),
                // Content Section
                CustomBooksOpinionsArticleContent(articleItem: articleItem),
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
