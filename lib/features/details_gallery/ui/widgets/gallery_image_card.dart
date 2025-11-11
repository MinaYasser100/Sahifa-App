import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/galleries_model/gallery_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class GalleryImageCard extends StatelessWidget {
  const GalleryImageCard({
    super.key,
    required this.galleryItem,
    required this.onTap,
  });

  final GalleryModel galleryItem;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child:
                  galleryItem.imageUrl != null &&
                      galleryItem.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: galleryItem.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: isDarkMode
                              ? Colors.grey[600]
                              : Colors.grey[400],
                        ),
                      ),
                    )
                  : Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
            ),
          ),

          // Title & Description
          if (galleryItem.title != null || galleryItem.imageDescription != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (galleryItem.title != null &&
                      galleryItem.title!.isNotEmpty)
                    Text(
                      galleryItem.title!,
                      style: AppTextStyles.styleMedium16sp(context).copyWith(
                        color: isDarkMode
                            ? ColorsTheme().whiteColor
                            : ColorsTheme().blackColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
