import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioBookCardWidget extends StatelessWidget {
  final AudioItemModel audioItem;

  const AudioBookCardWidget({super.key, required this.audioItem});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push(Routes.audioBookDetails, extra: audioItem);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: audioItem.thumbnailUrl ?? '',
                width: 160,
                height: 220,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 160,
                  height: 220,
                  color: isDarkMode
                      ? ColorsTheme().cardColor
                      : ColorsTheme().grayColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: isDarkMode
                          ? ColorsTheme().primaryDark
                          : ColorsTheme().primaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 160,
                  height: 220,
                  color: isDarkMode
                      ? ColorsTheme().cardColor
                      : ColorsTheme().grayColor,
                  child: Icon(
                    Icons.error_outline,
                    color: isDarkMode
                        ? ColorsTheme().whiteColor
                        : ColorsTheme().blackColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              audioItem.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
