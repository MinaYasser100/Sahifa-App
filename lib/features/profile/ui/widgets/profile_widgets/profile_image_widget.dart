import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.isDark,
    required this.imageUrl,
    this.size = 50,
  });

  final bool isDark;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size,
        backgroundColor: isDark
            ? ColorsTheme().primaryLight
            : ColorsTheme().primaryColor,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            width: size * 2,
            height: size * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                CircularProgressIndicator(color: ColorsTheme().whiteColor),
            errorWidget: (context, url, error) =>
                Icon(Icons.person, color: ColorsTheme().whiteColor, size: size),
          ),
        ),
      );
    }

    // Default profile image
    return CircleAvatar(
      backgroundColor: isDark
          ? ColorsTheme().primaryLight
          : ColorsTheme().primaryColor,
      radius: size,
      child: Icon(Icons.person, color: ColorsTheme().whiteColor, size: size),
    );
  }
}
