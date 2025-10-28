import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class DescriptionSection extends StatelessWidget {
  final AudioItemModel audioItem;
  final bool isDark;

  const DescriptionSection({
    super.key,
    required this.audioItem,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'description'.tr(),
              style: AppTextStyles.styleBold24sp(context).copyWith(
                color: isDark
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().blackColor,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              audioItem.summary ?? 'No description available',
              style: AppTextStyles.styleMedium16sp(context).copyWith(
                color: isDark
                    ? ColorsTheme().grayColor
                    : ColorsTheme().blackColor.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
