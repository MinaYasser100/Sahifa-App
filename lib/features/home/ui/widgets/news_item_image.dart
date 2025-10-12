import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class NewsItemImage extends StatelessWidget {
  const NewsItemImage({super.key, required this.imageUrl, this.height = 150});

  final String imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: ColorsTheme().primaryColor,
            child: const Center(
              child: Icon(Icons.image, size: 40, color: Colors.white),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            color: ColorsTheme().primaryColor.withValues(alpha: 0.2),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
