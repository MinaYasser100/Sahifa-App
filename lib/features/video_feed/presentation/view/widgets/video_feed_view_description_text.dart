import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/theme/app_style.dart';

class VideoFeedViewDescriptionText extends StatelessWidget {
  const VideoFeedViewDescriptionText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();
    return Text(
      text.length > 30 ? '${text.substring(0, 30)}...' : text,
      style: AppTextStyles.styleRegular18sp(
        context,
      ).copyWith(color: colors.whiteColor),
    );
  }
}
