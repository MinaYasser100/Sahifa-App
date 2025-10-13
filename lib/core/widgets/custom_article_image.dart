import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CustomArticleImage extends StatelessWidget {
  const CustomArticleImage({
    super.key,
    required this.imageUrl,
    this.height = 140,
    this.width = double.infinity,
    this.changeBorderRadius = false,
  });

  final String imageUrl;
  final double height;
  final double width;
  final bool changeBorderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: changeBorderRadius ? Radius.zero : Radius.circular(12),
        bottomLeft: changeBorderRadius ? Radius.circular(12) : Radius.zero,
      ),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            color: ColorsTheme().primaryColor,
            child: Center(
              child: Icon(
                Icons.image,
                size: 40,
                color: ColorsTheme().whiteColor,
              ),
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
