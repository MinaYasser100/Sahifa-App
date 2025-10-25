import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class VideoCategoryAndShareButton extends StatelessWidget {
  const VideoCategoryAndShareButton({
    super.key,
    required this.video,
    required this.isDarkMode,
  });

  final VideoModel video;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Category Badge
        FadeInLeft(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                  : ColorsTheme().primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().primaryColor,
                width: 1,
              ),
            ),
            child: Text(
              video.categoryName ?? 'No Category Name'.tr(),
              style: AppTextStyles.styleMedium16sp(context).copyWith(),
            ),
          ),
        ), // Share Button
        FadeInRight(
          child: CircleAvatar(
            backgroundColor: isDarkMode
                ? ColorsTheme().whiteColor
                : ColorsTheme().primaryColor.withValues(alpha: 0.1),
            child: InkWell(
              onTap: () {
                // Handle share action
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  FontAwesomeIcons.share,
                  color: ColorsTheme().primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
