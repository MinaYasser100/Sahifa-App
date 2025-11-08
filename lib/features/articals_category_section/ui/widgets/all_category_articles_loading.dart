import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class AllCategoryArticlesLoadingWidget extends StatelessWidget {
  const AllCategoryArticlesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Show 5 skeleton items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildSkeletonArticleItem(isDarkMode),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonArticleItem(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
            : ColorsTheme().primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                  : ColorsTheme().primaryLight.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge skeleton
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 12),
                // Title skeleton - 2 lines
                Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity * 0.7,
                  height: 18,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                // Description skeleton - 2 lines
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity * 0.8,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                // Date and views skeleton
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                            : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                            : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
