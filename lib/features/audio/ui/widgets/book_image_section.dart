import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/utils/colors.dart';

class BookImageSection extends StatelessWidget {
  final AudioItemModel audioItem;
  final bool isDark;

  const BookImageSection({
    super.key,
    required this.audioItem,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 650),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: CachedNetworkImage(
            imageUrl: audioItem.thumbnailUrl ?? '',
            width: 210,
            height: 290,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: isDark ? ColorsTheme().cardColor : ColorsTheme().grayColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.broken_image,
              size: 44,
              color: isDark ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
