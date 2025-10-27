import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sahifa/core/utils/colors.dart';

// كاش مانجر مخصص
class CustomCacheManager extends CacheManager {
  static const key = "customCache";
  static final CustomCacheManager _instance = CustomCacheManager._internal();

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._internal()
    : super(
        Config(key, stalePeriod: Duration(days: 7), maxNrOfCacheObjects: 300),
      );
}

class BannerImage extends StatelessWidget {
  const BannerImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: CustomCacheManager(),
      fadeInDuration: Duration(milliseconds: 300),
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
