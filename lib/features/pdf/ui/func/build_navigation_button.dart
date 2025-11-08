import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

Widget buildNavigationButton({
  required IconData icon,
  required VoidCallback onPressed,
  required bool isLeft,
}) {
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOutBack,
    builder: (context, value, child) {
      return Transform.scale(scale: value, child: child);
    },
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorsTheme().primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(icon, color: ColorsTheme().primaryLight, size: 32),
        ),
      ),
    ),
  );
}
