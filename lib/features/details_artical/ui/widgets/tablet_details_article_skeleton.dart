import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletDetailsArticleSkeleton extends StatelessWidget {
  const TabletDetailsArticleSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side - Image skeleton
            Expanded(
              flex: 2,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 32),

            // Right Side - Content skeleton
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  Container(
                    width: double.infinity,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                          : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 250,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                          : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Meta info skeleton
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 16,
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
                      const SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 16,
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
                  const SizedBox(height: 24),

                  // Content lines skeleton
                  ...List.generate(8, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: index == 7 ? 200 : double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.15,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.15,
                                ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
