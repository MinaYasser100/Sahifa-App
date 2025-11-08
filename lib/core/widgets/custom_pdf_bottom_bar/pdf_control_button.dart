import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfControlButton extends StatelessWidget {
  const PdfControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isEnabled
              ? ColorsTheme().whiteColor.withValues(alpha: 0.2)
              : ColorsTheme().whiteColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorsTheme().whiteColor.withValues(
              alpha: isEnabled ? 0.3 : 0.1,
            ),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isEnabled
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().whiteColor.withValues(alpha: 0.4),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isEnabled
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().whiteColor.withValues(alpha: 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
