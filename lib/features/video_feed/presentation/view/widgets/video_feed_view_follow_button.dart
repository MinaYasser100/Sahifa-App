import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/theme/app_style.dart';

class VideoFeedViewFollowButton extends StatelessWidget {
  const VideoFeedViewFollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.whiteColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Follow',
        style: AppTextStyles.styleMedium16sp(
          context,
        ).copyWith(color: colors.whiteColor),
      ),
    );
  }
}
