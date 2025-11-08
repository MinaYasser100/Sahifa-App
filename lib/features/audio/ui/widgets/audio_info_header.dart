import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioInfoHeader extends StatelessWidget {
  final String? title;
  final String? authorName;

  const AudioInfoHeader({
    super.key,
    required this.title,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: Column(
        children: [
          Text(
            title ?? 'No Title'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.styleBold24sp(context).copyWith(
              color: isDark
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().blackColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            authorName ?? 'unknown_author'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.styleMedium16sp(
              context,
            ).copyWith(color: ColorsTheme().primaryLight),
          ),
        ],
      ),
    );
  }
}
