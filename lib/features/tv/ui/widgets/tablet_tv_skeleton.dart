import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletTvSkeleton extends StatelessWidget {
  const TabletTvSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // Banner skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 80,
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),

        // Title skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Container(
              width: 180,
              height: 24,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // Grid skeleton
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
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
                      // Video thumbnail skeleton
                      Expanded(
                        flex: 2,
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
                              Icons.play_circle_outline,
                              size: 48,
                              color: isDarkMode
                                  ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                                  : ColorsTheme().primaryLight.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      ),

                      // Title skeleton
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
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
                                width: 100,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                                      : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }
}
