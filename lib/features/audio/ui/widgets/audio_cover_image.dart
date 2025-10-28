import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioCoverImage extends StatelessWidget {
  final String? imageUrl;
  final String audioId;

  const AudioCoverImage({
    super.key,
    required this.imageUrl,
    required this.audioId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Center(
        child: Hero(
          tag: 'audio_$audioId',
          child: Container(
            width: 200,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorsTheme().primaryColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark
                      ? ColorsTheme().cardColor
                      : ColorsTheme().grayColor.withValues(alpha: 0.2),
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark
                      ? ColorsTheme().cardColor
                      : ColorsTheme().grayColor.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.audiotrack,
                    size: 80,
                    color: isDark
                        ? ColorsTheme().grayColor
                        : ColorsTheme().blackColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
