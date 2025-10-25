import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';

import 'widgets/video_details_body_view.dart';

class VideoDetailsView extends StatelessWidget {
  const VideoDetailsView({super.key, required this.video});

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          child: Text(
            'video_details'.tr(),
            style: AppTextStyles.styleBold20sp(context),
          ),
        ),
      ),
      body: VideoDetailsBodyView(video: video, isDarkMode: isDarkMode),
    );
  }
}
