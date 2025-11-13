import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/widgets/article_text_content.dart';
import 'package:sahifa/core/widgets/custom_article_item/widgets/author_info_row.dart';
import 'package:sahifa/core/widgets/custom_article_item/widgets/share_button.dart';

class CustomBooksOpinionsArticleContent extends StatelessWidget {
  const CustomBooksOpinionsArticleContent({
    super.key,
    required this.articleItem,
  });

  final ArticleModel articleItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Author Info & Share Button Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  context.push(Routes.authorProfileView, extra: articleItem);
                },
                child: AuthorInfoRow(
                  authorImage: articleItem.authorImage,
                  authorName: articleItem.authorName,
                  isDarkMode: isDarkMode,
                ),
              ),
            ),
            ShareButton(isDarkMode: isDarkMode),
          ],
        ),
        // const SizedBox(height: 8),
        // Article Content (Clickable)
        GestureDetector(
          onTap: () {
            context.push(Routes.detailsArticalView, extra: articleItem);
          },
          child: ArticleTextContent(
            categoryName: articleItem.categoryName,
            title: articleItem.title,
            publishedAt: articleItem.publishedAt,
            isDarkMode: isDarkMode,
          ),
        ),
      ],
    );
  }
}
