import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/tv/manager/tv_cubit/tv_cubit.dart';

class TvVideosEmpty extends StatelessWidget {
  const TvVideosEmpty({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInDown(
            child: Icon(
              Icons.videocam_off_rounded,
              size: 100,
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                  : ColorsTheme().primaryColor.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          FadeInRight(
            child: Text(
              'no_videos_available'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.7)
                    : ColorsTheme().primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInLeft(
            child: Text(
              'check_back_later_for_new_videos'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.5)
                    : ColorsTheme().primaryColor.withValues(alpha: 0.6),
              ),
            ),
          ),
          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<TvCubit>().fetchVideos();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text('retry'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsTheme().primaryColor,
                  foregroundColor: ColorsTheme().whiteColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
