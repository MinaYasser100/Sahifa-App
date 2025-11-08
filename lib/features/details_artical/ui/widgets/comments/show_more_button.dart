import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class ShowMoreButton extends StatelessWidget {
  final bool isDarkMode;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const ShowMoreButton({
    super.key,
    required this.isDarkMode,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: _buildDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              text,
              style: AppTextStyles.styleMedium14sp(
                context,
              ).copyWith(color: _getTextColor()),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: _getTextColor(), size: 20),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: isDarkMode
          ? Colors.grey[800]?.withValues(alpha: 0.5)
          : Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        width: 1,
      ),
    );
  }

  Color _getTextColor() {
    return isDarkMode
        ? ColorsTheme().whiteColor
        : ColorsTheme().blackColor.withValues(alpha: 0.87);
  }
}
