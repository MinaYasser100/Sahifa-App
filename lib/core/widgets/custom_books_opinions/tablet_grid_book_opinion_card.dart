import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/like_post/ui/like_button_widget.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_content.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_book_opinion_image.dart';

/// Widget specifically designed for tablet grid layout for books/opinions
class TabletGridBookOpinionCard extends StatelessWidget {
  const TabletGridBookOpinionCard({super.key, required this.articleItem});

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      flex: 2,
                      child: CustomBookOpinionImage(
                        imageUrl: articleItem.image ?? '',
                        authorName: articleItem.authorName ?? '',
                        containerWidth: constraints.maxWidth,
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
            );
          },
        ),
      ),
    );
  }
}
