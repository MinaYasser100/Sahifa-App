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

class TabletVideoDetailsBody extends StatelessWidget {
  const TabletVideoDetailsBody({
    super.key,
    required this.video,
    required this.isDarkMode,
  });

  final VideoModel video;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side - Video Thumbnail
            Expanded(flex: 3, child: VideoThumbnailSection(video: video)),

            const SizedBox(width: 32),

            // Right Side - Video Information
            Expanded(
              flex: 2,
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

                  const SizedBox(height: 16),

                  // Category and Views
                  VideoCategoryAndViewsRow(
                    video: video,
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(height: 12),

                  // Date
                  VideoDateRow(video: video, isDarkMode: isDarkMode),

                  const SizedBox(height: 24),

                  // Summary (Description)
                  if (video.summary != null && video.summary!.isNotEmpty)
                    VideoDescriptionSection(
                      video: video,
                      isDarkMode: isDarkMode,
                    ),

                  const SizedBox(height: 32),

                  // Watch Now Button
                  WatchNowButton(video: video),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
