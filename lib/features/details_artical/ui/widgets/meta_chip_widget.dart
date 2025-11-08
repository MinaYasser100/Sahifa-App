import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class MetaChipWidget extends StatelessWidget {
  const MetaChipWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.isDarkMode,
  });

  final IconData icon;
  final String text;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final color = isDarkMode
        ? ColorsTheme().secondaryLight
        : ColorsTheme().primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 7),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
