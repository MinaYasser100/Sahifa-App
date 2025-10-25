import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/utils/colors.dart';

class VideoCarouselDotsIndicator extends StatelessWidget {
  const VideoCarouselDotsIndicator({
    super.key,
    required this.videoBanners,
    required this.currentIndex,
    required this.onDotTap,
  });

  final List<VideoModel> videoBanners;
  final int currentIndex;
  final Function(int) onDotTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: videoBanners.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => onDotTap(entry.key),
          child: Container(
            width: currentIndex == entry.key ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: currentIndex == entry.key
                  ? isDarkMode
                        ? ColorsTheme().primaryLight
                        : ColorsTheme().primaryColor
                  : isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().grayColor.withValues(alpha: 0.4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
