import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CategoryCardContent extends StatelessWidget {
  const CategoryCardContent({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.isLarge,
  });

  final String categoryName;
  final IconData icon;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 16),
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
              child: Icon(icon, color: Colors.white, size: isLarge ? 32 : 24),
            ),
            SizedBox(height: isLarge ? 16 : 12),

            // Category Name
            Text(
              categoryName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorsTheme().primaryDark,
                fontSize: isLarge ? 18 : 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
