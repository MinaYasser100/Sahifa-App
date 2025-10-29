import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CategoryCardContent extends StatelessWidget {
  const CategoryCardContent({
    super.key,
    required this.categoryName,
    required this.icon,
  });

  final String categoryName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsTheme().primaryColor,
                    ColorsTheme().primaryLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FadeInRight(
                child: Icon(icon, color: ColorsTheme().whiteColor, size: 24),
              ),
            ),
            SizedBox(height: 12),

            // Category Name
            FadeInUp(
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().primaryDark,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
