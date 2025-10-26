import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class DetailsArticleLoadingWidget extends StatelessWidget {
  const DetailsArticleLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            height: 250,
            width: double.infinity,
            color: isDarkMode
                ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                : ColorsTheme().primaryLight.withValues(alpha: 0.2),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge skeleton
                Container(
                  width: 100,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),

                // Title skeleton (2 lines)
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),

                // Meta info skeleton (date, author, views)
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.15)
                            : ColorsTheme().primaryLight.withValues(
                                alpha: 0.15,
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
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.15)
                            : ColorsTheme().primaryLight.withValues(
                                alpha: 0.15,
                              ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 60,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.15)
                            : ColorsTheme().primaryLight.withValues(
                                alpha: 0.15,
                              ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Content skeleton (multiple lines)
                ...List.generate(8, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      width: index == 7
                          ? MediaQuery.of(context).size.width * 0.5
                          : double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
                            : ColorsTheme().primaryLight.withValues(alpha: 0.1),
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
    );
  }
}
