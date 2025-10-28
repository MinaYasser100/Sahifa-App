import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class AudioDetailsInfoSection extends StatelessWidget {
  final AudioItemModel audioItem;
  final bool isDark;
  final VoidCallback onListenPressed;

  const AudioDetailsInfoSection({
    super.key,
    required this.audioItem,
    required this.isDark,
    required this.onListenPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Column(
        children: [
          Text(
            audioItem.title ?? 'No Title'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.styleBold22sp(context).copyWith(
              color: isDark
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().blackColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            audioItem.authorName ?? 'غير محدد',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: ColorsTheme().primaryLight),
          ),
          const SizedBox(height: 8),
          Text(
            audioItem.duration ?? '00:00',
            textAlign: TextAlign.center,
            style: AppTextStyles.styleBold16sp(
              context,
            ).copyWith(color: ColorsTheme().grayColor),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: FadeIn(
              duration: const Duration(milliseconds: 350),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                label: Text(
                  'listen_now'.tr(),
                  style: AppTextStyles.styleBold16sp(context),
                ),
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                onPressed: onListenPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
