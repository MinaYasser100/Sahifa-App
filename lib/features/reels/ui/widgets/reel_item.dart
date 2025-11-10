import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sahifa/features/reels/manager/video_player_cubit/video_player_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_video_player.dart';

import 'reel_actions_section.dart';
import 'reel_caption_section.dart';
import 'reel_gradient_overlay.dart';

class ReelItem extends StatelessWidget {
  final Reel reel;
  final bool isCurrentPage;

  const ReelItem({super.key, required this.reel, required this.isCurrentPage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoPlayerCubit()..initializeVideo(reel.videoUrl),
      child: BlocConsumer<VideoPlayerCubit, VideoPlayerState>(
        listener: (context, state) {
          // لو الفيديو جاهز والصفحة الحالية active, نشغل الفيديو (auto play)
          if (state is VideoPlayerReady &&
              !state.isPlaying &&
              !state.isManuallyPaused &&
              isCurrentPage) {
            final cubit = context.read<VideoPlayerCubit>();
            if (!cubit.isClosed) {
              cubit.autoPlay();
            }
          }
        },
        builder: (context, state) {
          if (state is VideoPlayerLoading) {
            return Center(
              child: CircularProgressIndicator(color: ColorsTheme().whiteColor),
            );
          }

          if (state is VideoPlayerError) {
            return Center(
              child: Text(
                'error_loading_reels'.tr(),
                style: TextStyle(color: ColorsTheme().whiteColor),
              ),
            );
          }

          if (state is VideoPlayerReady) {
            final cubit = context.read<VideoPlayerCubit>();
            final controller = cubit.controller;

            if (controller == null) {
              return const SizedBox.shrink();
            }

            return _buildReelContent(
              context: context,
              controller: controller,
              isPlaying: state.isPlaying,
              cubit: cubit,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReelContent({
    required BuildContext context,
    required controller,
    required bool isPlaying,
    required VideoPlayerCubit cubit,
  }) {
    return VisibilityDetector(
      key: Key(reel.id),
      onVisibilityChanged: (info) {
        // تحقق إذا كان الـ Cubit مقفول قبل الاستدعاء
        if (!cubit.isClosed) {
          // لو الـ reel مش visible خالص، نوقف الفيديو (auto pause)
          if (info.visibleFraction < 0.5) {
            cubit.autoPause();
          }
          // لو الـ reel visible ومحتاج يشتغل (بس في حالة isCurrentPage)
          else if (info.visibleFraction > 0.5 && isCurrentPage) {
            cubit.autoPlay();
          }
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Player
          ReelVideoPlayer(
            controller: controller,
            isPlaying: isPlaying,
            onTogglePlay: () => cubit.togglePlayPause(),
          ),

          // Gradient overlay
          const ReelGradientOverlay(),

          // User info and caption
          ReelCaptionSection(reel: reel),

          // Action buttons (right side)
          ReelActionsSection(reel: reel),
        ],
      ),
    );
  }
}
