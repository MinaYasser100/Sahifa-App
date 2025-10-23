import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CategoriesHorizontalBarError extends StatelessWidget {
  const CategoriesHorizontalBarError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryDark
            : ColorsTheme().primaryColor,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: ColorsTheme().whiteColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(color: ColorsTheme().whiteColor, fontSize: 14),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                backgroundColor: ColorsTheme().whiteColor.withValues(
                  alpha: 0.2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(color: ColorsTheme().whiteColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
