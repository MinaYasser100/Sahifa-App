import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/theme/app_style.dart';

class VideoFeedViewInteractionButton extends StatelessWidget {
  const VideoFeedViewInteractionButton({
    required this.icon,
    required this.count,
    super.key,
    this.color,
  });

  final IconData icon;
  final int count;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, color: color ?? colors.whiteColor, size: 36),
        Text(
          count.toString(),
          style: AppTextStyles.styleMedium14sp(
            context,
          ).copyWith(color: colors.whiteColor),
        ),
      ],
    );
  }
}
