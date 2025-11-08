import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletCardTitle extends StatelessWidget {
  const TabletCardTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: AppTextStyles.styleBold16sp(context).copyWith(
        color: isDarkMode ? ColorsTheme().whiteColor : ColorsTheme().blackColor,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
