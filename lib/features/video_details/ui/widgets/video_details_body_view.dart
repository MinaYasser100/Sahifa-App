import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';

import 'video_category_and_views_row.dart';
import 'video_date_row.dart';
import 'video_description_section.dart';
import 'video_thumbnail_section.dart';
import 'watch_now_button.dart';

class VideoDetailsBodyView extends StatelessWidget {
  const VideoDetailsBodyView({
    super.key,
    required this.video,
    required this.isDarkMode,
  });

  final VideoModel video;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail with Play Button
          VideoThumbnailSection(video: video),

          const SizedBox(height: 16),

          // Video Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Title
                FadeInLeft(
                  child: Text(
                    video.title ?? 'No Title'.tr(),
                    style: AppTextStyles.styleBold24sp(context),
                  ),
                ),

                const SizedBox(height: 12),

                // Category and Views
                VideoCategoryAndViewsRow(video: video, isDarkMode: isDarkMode),

                const SizedBox(height: 12),

                // Date
                VideoDateRow(video: video, isDarkMode: isDarkMode),

                const SizedBox(height: 20),

                // Summary (Description)
                if (video.content != null && video.content!.isNotEmpty)
                  VideoDescriptionSection(video: video, isDarkMode: isDarkMode),

                const SizedBox(height: 24),

                // Watch Now Button
                WatchNowButton(video: video),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
