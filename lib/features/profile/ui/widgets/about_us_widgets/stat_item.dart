import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? colors.secondaryColor : colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? colors.softBlue : colors.grayColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
