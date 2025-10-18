import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

class DetailsArticleContent extends StatelessWidget {
  const DetailsArticleContent({super.key, required this.articalModel});

  final ArticleItemModel articalModel;

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          FadeInLeft(
            child: Text(
              articalModel.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? ColorsTheme().secondaryLight
                    : ColorsTheme().primaryLight,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Metadata Row
          FadeInLeft(
            child: Row(
              children: [
                // Date
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
                        : ColorsTheme().primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: isDarkMode
                            ? ColorsTheme().secondaryLight
                            : ColorsTheme().primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatDate(articalModel.date),
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode
                              ? ColorsTheme().secondaryLight
                              : ColorsTheme().primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          FadeInUp(
            child: Divider(
              color: isDarkMode
                  ? ColorsTheme().primaryLight.withValues(alpha: 0.3)
                  : ColorsTheme().dividerColor,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 24),

          // Description
          FadeInUp(
            child: Text(
              articalModel.description,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.95)
                    : Colors.grey[800],
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Full Article Content (dummy text for now)
          FadeInUp(
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
              'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
              'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.\n\n'
              'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.85)
                    : Colors.grey[700],
                height: 1.8,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
