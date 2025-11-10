import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.isDark,
    required this.imageUrl,
  });

  final bool isDark;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: isDark
            ? ColorsTheme().primaryLight
            : ColorsTheme().primaryColor,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                CircularProgressIndicator(color: ColorsTheme().whiteColor),
            errorWidget: (context, url, error) =>
                Icon(Icons.person, color: ColorsTheme().whiteColor, size: 50),
          ),
        ),
      );
    }

    // Default profile image
    return CircleAvatar(
      backgroundColor: isDark
          ? ColorsTheme().primaryLight
          : ColorsTheme().primaryColor,
      radius: 50,
      child: Icon(Icons.person, color: ColorsTheme().whiteColor, size: 50),
    );
  }
}
