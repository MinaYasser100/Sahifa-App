import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class LanguageOption extends StatelessWidget {
  const LanguageOption({
    super.key,
    required this.languageName,
    required this.languageCode,
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  final String languageName;
  final String languageCode;
  final Locale locale;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? ColorsTheme().primaryColor
                : Colors.grey.withValues(alpha: 0.7),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Language Flag/Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                          ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                          : ColorsTheme().primaryColor.withValues(alpha: 0.3))
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  languageCode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? ColorsTheme().primaryColor
                        : isDark
                        ? ColorsTheme().whiteColor
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Language Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: AppTextStyles.styleMedium16sp(context).copyWith(
                      color: isSelected
                          ? (isDark
                                ? ColorsTheme().whiteColor
                                : ColorsTheme().primaryColor)
                          : (isDark
                                ? ColorsTheme().whiteColor
                                : ColorsTheme().blackColor),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  if (isSelected)
                    Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? ColorsTheme().whiteColor.withValues(alpha: 0.5)
                            : ColorsTheme().primaryColor.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),

            // Check Mark with Animation
            if (isSelected)
              ZoomIn(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorsTheme().primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
