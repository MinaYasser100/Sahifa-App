import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/widgets/custom_image_widget.dart';
import 'package:sahifa/features/video_details/ui/widgets/details_video_duration_badge.dart';
import 'package:sahifa/features/video_details/ui/widgets/details_video_play_button.dart';

class VideoThumbnailSection extends StatelessWidget {
  const VideoThumbnailSection({super.key, required this.video});

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Stack(
        children: [
          CustomImageWidget(
            imageUrl: video.videoThumbnailUrl ?? '',
            height: 250,
            changeBorderRadius: true,
          ),
          DetailsVideoPlayButton(),
          DetailsVideoDurationBadge(video: video),
        ],
      ),
    );
  }
}
