import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/func/format_date_from_utc.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/tv/ui/func/video_formats_helper.dart';

class VideoDateAndViews extends StatelessWidget {
  const VideoDateAndViews({
    super.key,
    required this.isDarkMode,
    required this.video,
  });

  final bool isDarkMode;

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 150),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.clock,
            size: 12,
            color: isDarkMode
                ? ColorsTheme().whiteColor.withValues(alpha: 0.6)
                : ColorsTheme().grayColor,
          ),
          const SizedBox(width: 6),
          Text(
            formatDateFromUTC(video.publishedAt ?? ''),
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.6)
                  : ColorsTheme().grayColor,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            FontAwesomeIcons.eye,
            size: 12,
            color: isDarkMode
                ? ColorsTheme().whiteColor.withValues(alpha: 0.6)
                : ColorsTheme().grayColor,
          ),
          const SizedBox(width: 6),
          Text(
            '${VideosHelper.formatViewCount(video.viewCount ?? 0)} views',
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.6)
                  : ColorsTheme().grayColor,
            ),
          ),
        ],
      ),
    );
  }
}
