import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/tv/data/models/video_item_model.dart';

class VideoCategoryAndShareButton extends StatelessWidget {
  const VideoCategoryAndShareButton({
    super.key,
    required this.video,
    required this.isDarkMode,
  });

  final VideoItemModel video;
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
              color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: ColorsTheme().primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              video.category,
              style: AppTextStyles.styleMedium16sp(context).copyWith(
                color: isDarkMode
                    ? ColorsTheme().secondaryLight
                    : ColorsTheme().primaryColor,
              ),
            ),
          ),
        ), // Share Button
        FadeInRight(
          child: InkWell(
            onTap: () {
              // Handle share action
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                FontAwesomeIcons.share,
                size: 18,
                color: isDarkMode
                    ? ColorsTheme().secondaryLight
                    : ColorsTheme().primaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
