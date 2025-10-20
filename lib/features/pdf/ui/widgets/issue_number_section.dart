import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class IssueNumberSection extends StatelessWidget {
  const IssueNumberSection({
    super.key,
    required this.isDarkMode,
    required this.issueNumber,
  });

  final bool isDarkMode;
  final String issueNumber;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FadeInDown(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorsTheme().primaryColor.withValues(alpha: 0.15)
                : ColorsTheme().softBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.newspaper,
                size: 18,
                color: isDarkMode
                    ? ColorsTheme().secondaryLight
                    : ColorsTheme().primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                issueNumber,
                style: AppTextStyles.styleBold14sp(context).copyWith(
                  color: isDarkMode
                      ? ColorsTheme().secondaryLight
                      : ColorsTheme().primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
