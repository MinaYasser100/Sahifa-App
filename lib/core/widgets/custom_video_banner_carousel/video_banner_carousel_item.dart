import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_image.dart';
import 'package:sahifa/features/tv/ui/widgets/video_duration_badge.dart';
import 'package:sahifa/features/tv/ui/widgets/video_play_button.dart';

class VideoBannerCarouselItem extends StatelessWidget {
  const VideoBannerCarouselItem({super.key, required this.videoBanner});

  final VideoModel videoBanner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Video Thumbnail
          CustomArticleImage(
            imageUrl: videoBanner.videoThumbnailUrl ?? '',
            height: 200,
          ),

          // Play Button Overlay
          VideoPlayButton(),

          // Duration Badge
          VideoDurationBadge(video: videoBanner),

          // Video Title Overlay (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeInUp(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: Text(
                  videoBanner.title ?? 'No Title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
