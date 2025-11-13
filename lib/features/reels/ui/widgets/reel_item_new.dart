import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/utils/video_url_helper.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:sahifa/features/reels/manager/video_player_cubit/video_player_cubit.dart';
import 'package:sahifa/features/reels/manager/preload_video_cache.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_video_player.dart';
import 'package:sahifa/features/reels/ui/widgets/youtube_reel_player.dart';

import 'reel_actions_section.dart';
import 'reel_caption_section.dart';
import 'reel_gradient_overlay.dart';

class ReelItem extends StatelessWidget {
  final Reel reel;
  final bool isCurrentPage;

  const ReelItem({super.key, required this.reel, required this.isCurrentPage});

  @override
  Widget build(BuildContext context) {
    final videoType = VideoUrlHelper.getVideoType(reel.videoUrl);

    // لو YouTube video
    if (videoType == VideoType.youtube) {
      return _buildYouTubeReel(context);
    }

    // لو Direct video (mp4, etc)
    return _buildDirectVideoReel(context);
  }

  Widget _buildYouTubeReel(BuildContext context) {
    final videoId = VideoUrlHelper.extractYouTubeId(reel.videoUrl);

    if (videoId == null) {
      return Center(
        child: Text(
          'invalid_youtube_url'.tr(),
          style: TextStyle(color: ColorsTheme().whiteColor),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // YouTube Player
        YouTubeReelPlayer(videoId: videoId, isCurrentPage: isCurrentPage),

        // Gradient overlay
        //const ReelGradientOverlay(),

        // User info and caption
        ReelCaptionSection(reel: reel),

        // Action buttons (right side)
        ReelActionsSection(reel: reel),
      ],
    );
  }

  Widget _buildDirectVideoReel(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final preloaded = PreloadVideoCache.instance.get(reel.videoUrl);
        final cubit = VideoPlayerCubit(preloadedController: preloaded);
        if (preloaded == null) {
          // not preloaded — initialize normally
          cubit.initializeVideo(reel.videoUrl);
        }
        return cubit;
      },
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
            return Stack(
              fit: StackFit.expand,
              children: [
                // show thumbnail while loading to avoid white flash
                if ((reel.thumbnailUrl ?? '').isNotEmpty)
                  Image.network(
                    reel.thumbnailUrl ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(color: Colors.black);
                    },
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.black),
                  ),
                Center(
                  child: CircularProgressIndicator(
                    color: ColorsTheme().whiteColor,
                  ),
                ),
              ],
            );
          }

          if (state is VideoPlayerError) {
            return Stack(
              fit: StackFit.expand,
              children: [
                if ((reel.thumbnailUrl ?? '').isNotEmpty)
                  Image.network(
                    reel.thumbnailUrl ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.black),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: ColorsTheme().errorColor,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'error_loading_video'.tr(),
                        style: TextStyle(color: ColorsTheme().whiteColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: ColorsTheme().whiteColor.withValues(
                            alpha: 0.7,
                          ),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is VideoPlayerReady) {
            final cubit = context.read<VideoPlayerCubit>();
            final controller = cubit.controller;

            if (controller == null) {
              return const SizedBox.shrink();
            }

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
                    isPlaying: state.isPlaying,
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

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
