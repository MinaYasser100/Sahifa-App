import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/widgets/author_info_row.dart';

import 'meta_chip_widget.dart';

class DetailsArticleContent extends StatelessWidget {
  const DetailsArticleContent({super.key, required this.articalModel});

  final ArticleModel articalModel;

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
              articalModel.title ?? '',
              style: AppTextStyles.styleBold20sp(context).copyWith(
                color: isDarkMode
                    ? ColorsTheme().secondaryLight
                    : ColorsTheme().primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 10),
          if (articalModel.ownerIsAuthor == true)
            GestureDetector(
              onTap: () {
                context.push(Routes.authorProfileView, extra: articalModel);
              },
              child: AuthorInfoRow(
                authorImage: articalModel.authorImage,
                authorName: articalModel.authorName,
                isDarkMode: isDarkMode,
              ),
            ),
          if (articalModel.ownerIsAuthor == true) const SizedBox(height: 16),
          // Metadata Row
          FadeInLeft(
            child: Row(
              children: [
                MetaChipWidget(
                  icon: Icons.calendar_today,
                  text: formatDate(
                    articalModel.publishedAt != null
                        ? DateTime.parse(articalModel.publishedAt!)
                        : DateTime.now(),
                  ),
                  isDarkMode: isDarkMode,
                ),
                Container(
                  width: 2,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: isDarkMode
                      ? ColorsTheme().whiteColor.withValues(alpha: 0.9)
                      : Colors.grey[900],
                ),
                MetaChipWidget(
                  icon: Icons.visibility_outlined,
                  text: formatViewCount(articalModel.viewsCount ?? 0),
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Divider
          FadeInUp(
            child: Divider(
              color: isDarkMode
                  ? ColorsTheme().primaryLight.withValues(alpha: 0.9)
                  : ColorsTheme().dividerColor,
              thickness: 1,
            ),
          ),
          const SizedBox(height: 24),

          // Description
          FadeInUp(
            child: Text(
              articalModel.content ?? '',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.95)
                    : Colors.grey[800],
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ),
          //const SizedBox(height: 24),
          // // Full Article Content (dummy text for now)
          // FadeInUp(
          //   child: Text(
          //     "article_long_content".tr(),
          //     style: TextStyle(
          //       fontSize: 18,
          //       color: isDarkMode
          //           ? ColorsTheme().whiteColor.withValues(alpha: 0.85)
          //           : Colors.grey[700],
          //       height: 1.8,
          //       letterSpacing: 0.2,
          //     ),
          //   ),
          // ),
          //const SizedBox(height: 10),
        ],
      ),
    );
  }
}

String formatViewCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  } else {
    return count.toString();
  }
}
