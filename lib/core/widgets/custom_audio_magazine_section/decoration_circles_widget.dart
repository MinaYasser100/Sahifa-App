import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class DecorationCirclesWidget extends StatelessWidget {
  const DecorationCirclesWidget({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: -10,
          right: -20,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: -20,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -10,
          left: 80,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: -10,
          right: 80,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
