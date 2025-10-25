import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_image.dart';

import 'video_category_and_share_button.dart';
import 'video_date_and_views.dart';
import 'video_duration_badge.dart';
import 'video_play_button.dart';

class VideoItemCard extends StatelessWidget {
  const VideoItemCard({super.key, required this.video});

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorsTheme().primaryDark
              : ColorsTheme().whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to video details page
            context.push(Routes.videoDetailsView, extra: video);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Thumbnail with Play Button and Duration
              Stack(
                children: [
                  // Thumbnail Image
                  CustomArticleImage(
                    imageUrl: video.videoThumbnailUrl ?? '',
                    height: 200,
                  ),
                  // Play Button Overlay
                  VideoPlayButton(),
                  // Duration Badge
                  VideoDurationBadge(video: video),
                ],
              ),

              // Video Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and Share Button Row
                    VideoCategoryAndShareButton(
                      video: video,
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 10),

                    // Video Title
                    FadeInLeft(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        video.title ?? 'No Title'.tr(),
                        style: AppTextStyles.styleBold16sp(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Date and View Count
                    VideoDateAndViews(isDarkMode: isDarkMode, video: video),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
