import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/details_artical/ui/widgets/details_article_content.dart'
    as VideosHelper;

class VideoCategoryAndViewsRow extends StatelessWidget {
  const VideoCategoryAndViewsRow({
    super.key,
    required this.video,
    required this.isDarkMode,
  });

  final VideoModel video;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 100),
      child: Row(
        children: [
          // Category
          if (video.categoryName != null && video.categoryName!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
                    : ColorsTheme().primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                video.categoryName!,
                style: AppTextStyles.styleRegular14sp(context).copyWith(
                  color: isDarkMode
                      ? ColorsTheme().primaryLight
                      : ColorsTheme().primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(width: 12),

          // Views Count
          Row(
            children: [
              Icon(
                FontAwesomeIcons.eye,
                size: 16,
                color: isDarkMode
                    ? ColorsTheme().grayColor.withValues(alpha: 0.4)
                    : ColorsTheme().grayColor.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                VideosHelper.formatViewCount(video.viewsCount ?? 0),
                style: AppTextStyles.styleRegular14sp(context).copyWith(
                  color: isDarkMode
                      ? ColorsTheme().grayColor.withValues(alpha: 0.4)
                      : ColorsTheme().grayColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
