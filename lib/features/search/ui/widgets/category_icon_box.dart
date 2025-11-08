import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CategoryIconBox extends StatelessWidget {
  const CategoryIconBox({super.key, required this.icon, required this.isLarge});

  final IconData icon;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorsTheme().primaryColor, ColorsTheme().primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.white, size: isLarge ? 32 : 24),
    );
  }
}
