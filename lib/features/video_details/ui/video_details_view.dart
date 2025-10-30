import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';

import 'widgets/tablet_video_details_body.dart';
import 'widgets/video_details_body_view.dart';

class VideoDetailsView extends StatelessWidget {
  const VideoDetailsView({super.key, required this.video});

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: FadeIn(
          child: Text(
            'video_details'.tr(),
            style: AppTextStyles.styleBold20sp(context),
          ),
        ),
      ),
      body: isTablet
          ? TabletVideoDetailsBody(video: video, isDarkMode: isDarkMode)
          : VideoDetailsBodyView(video: video, isDarkMode: isDarkMode),
    );
  }
}
