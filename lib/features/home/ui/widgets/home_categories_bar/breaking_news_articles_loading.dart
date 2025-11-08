import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class BreakingNewsArticlesLoading extends StatelessWidget {
  const BreakingNewsArticlesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Show 5 skeleton items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSkeletonArticleCard(isDarkMode),
        );
      },
    );
  }

  Widget _buildSkeletonArticleCard(bool isDarkMode) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
            : ColorsTheme().primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image skeleton
            Container(
              width: 100,
              height: 96,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title skeleton (2 lines)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.2,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.2,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: double.infinity * 0.7,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.2,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.2,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Category and date skeleton
                  Row(
                    children: [
                      // Category skeleton
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.2,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.2,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Date skeleton
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.2,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.2,
                                ),
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
      ),
    );
  }
}
