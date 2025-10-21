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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: changeBorderRadius
            ? BorderRadius.zero
            : BorderRadius.circular(10),
        border: changeBorderRadius
            ? null
            : Border.all(
                color: ColorsTheme().grayColor.withValues(alpha: 0.3),
                width: 2,
              ),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: changeBorderRadius ? Radius.zero : Radius.circular(8),
          topRight: changeBorderRadius ? Radius.zero : Radius.circular(8),
          bottomLeft: changeBorderRadius ? Radius.zero : Radius.circular(8),
          bottomRight: changeBorderRadius ? Radius.zero : Radius.circular(8),
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
      ),
    );
  }
}
