import 'package:cached_network_image/cached_network_image.dart';
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            height: height,
            color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorsTheme().primaryColor,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: height,
            color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
            child: Center(
              child: Icon(
                Icons.image_not_supported,
                size: 40,
                color: ColorsTheme().primaryColor.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
