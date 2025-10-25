import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/func/format_date.dart' as VideosHelper;
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class VideoDateRow extends StatelessWidget {
  const VideoDateRow({
    super.key,
    required this.video,
    required this.isDarkMode,
  });

  final VideoModel video;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 150),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.calendar,
            size: 14,
            color: isDarkMode
                ? ColorsTheme().grayColor.withValues(alpha: 0.4)
                : ColorsTheme().grayColor.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 6),
          Text(
            video.publishedAt != null
                ? VideosHelper.formatDate(DateTime.parse(video.publishedAt!))
                : 'no_date'.tr(),
            style: AppTextStyles.styleRegular14sp(context).copyWith(
              color: isDarkMode
                  ? ColorsTheme().grayColor.withValues(alpha: 0.4)
                  : ColorsTheme().grayColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
