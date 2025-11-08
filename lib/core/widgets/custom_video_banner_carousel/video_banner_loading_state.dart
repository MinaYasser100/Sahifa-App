import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class VideoBannerLoadingState extends StatelessWidget {
  const VideoBannerLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: ColorsTheme().primaryColor),
              const SizedBox(height: 16),
              Text(
                'loading_video_banners'.tr(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
