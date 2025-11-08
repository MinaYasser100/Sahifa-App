import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioCategorySkeletonLoader extends StatelessWidget {
  const AudioCategorySkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category name skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 150,
            height: 24,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                  : ColorsTheme().primaryLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Horizontal audio items skeleton
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(left: 12),
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
                      width: 160,
                      height: 220,
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
                              ? ColorsTheme().primaryColor.withValues(
                                  alpha: 0.3,
                                )
                              : ColorsTheme().primaryLight.withValues(
                                  alpha: 0.3,
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
                            width: 120,
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
                          const SizedBox(height: 6),
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
