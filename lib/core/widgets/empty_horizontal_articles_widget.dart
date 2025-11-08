import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class EmptyHorizontalArticlesWidget extends StatelessWidget {
  const EmptyHorizontalArticlesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 325,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article_outlined,
                size: 60,
                color: isDarkMode
                    ? ColorsTheme().grayColor.withValues(alpha: 0.3)
                    : ColorsTheme().grayColor.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'no_articles_available'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? ColorsTheme().grayColor.withValues(alpha: 0.7)
                      : ColorsTheme().grayColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
