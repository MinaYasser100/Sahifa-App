import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletAudioCategorySkeleton extends StatelessWidget {
  const TabletAudioCategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category name skeleton
        Container(
          width: 180,
          height: 28,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                : ColorsTheme().primaryLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        // Grid skeleton (4 columns for tablet)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
            itemBuilder: (context, index) {
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
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                              : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.headphones,
                            size: 48,
                            color: isDarkMode
                                ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                                : ColorsTheme().primaryLight.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title skeleton
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
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
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                                  : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 32),
      ],
    );
  }
}
