import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/tv/ui/func/video_formats_helper.dart';

class WatchNowButton extends StatelessWidget {
  const WatchNowButton({super.key, required this.video});

  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 250),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () => VideosHelper.launchVideoUrl(context, video),
          icon: Icon(
            FontAwesomeIcons.play,
            size: 20,
            color: ColorsTheme().whiteColor,
          ),
          label: Text(
            'watch_it_now'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsTheme().whiteColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsTheme().primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
