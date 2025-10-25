import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
        child: Center(
          child: CircularProgressIndicator(
            color: ColorsTheme().primaryColor,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 50,
            color: ColorsTheme().primaryColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
