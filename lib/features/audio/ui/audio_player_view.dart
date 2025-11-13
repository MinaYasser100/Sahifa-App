import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/widgets/adaptive_layout.dart';
import 'package:sahifa/features/audio/data/repo/audio_player_repo.dart';
import 'package:sahifa/features/audio/manager/audio_player_cubit/audio_player_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_cover_image.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_info_header.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_player_controls.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_progress_bar.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_speed_control.dart';
import 'package:sahifa/features/audio/ui/widgets/tablet_audio_player_body.dart';

class AudioPlayerView extends StatelessWidget {
  final AudioItemModel audioItem;

  const AudioPlayerView({super.key, required this.audioItem});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AudioPlayerCubit(AudioPlayerRepoImpl())
            ..initializeAudio(audioItem.audioUrl!),
      child: AdaptiveLayout(
        mobileLayout: (context) => _AudioPlayerBody(audioItem: audioItem),
        tabletLayout: (context) => TabletAudioPlayerBody(audioItem: audioItem),
        desktopLayout: (context) => TabletAudioPlayerBody(audioItem: audioItem),
      ),
    );
  }
}

class _AudioPlayerBody extends StatelessWidget {
  final AudioItemModel audioItem;

  const _AudioPlayerBody({required this.audioItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          audioItem.title ?? "No Title".tr(),
          style: AppTextStyles.styleBold18sp(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Cover Image
                AudioCoverImage(
                  imageUrl: audioItem.imageUrl,
                  audioId: audioItem.id ?? '',
                ),
                //const SizedBox(height: 20),
                // Title and Author
                AudioInfoHeader(
                  title: audioItem.title,
                  authorName: audioItem.authorName,
                ),
                //const SizedBox(height: 20),
                // Progress Bar and Controls
                BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                  builder: (context, state) {
                    final cubit = context.read<AudioPlayerCubit>();
                    Duration position = Duration.zero;
                    Duration duration = Duration.zero;
                    bool isPlaying = false;
                    bool isBuffering = false;

                    if (state is AudioPlayerPlaying) {
                      position = state.position;
                      duration = state.duration;
                      isPlaying = true;
                    } else if (state is AudioPlayerPaused) {
                      position = state.position;
                      duration = state.duration;
                    } else if (state is AudioPlayerBuffering) {
                      position = state.position;
                      duration = state.duration;
                      isBuffering = true;
                    }

                    return FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          // Progress Bar
                          AudioProgressBar(
                            position: position,
                            duration: duration,
                            onSeek: (newPosition) => cubit.seekTo(newPosition),
                            formatDuration: cubit.formatDuration,
                          ),
                          const SizedBox(height: 20),
                          // Control Buttons
                          AudioPlayerControls(
                            isPlaying: isPlaying,
                            isBuffering: isBuffering,
                            onPlayPause: () => cubit.togglePlayPause(),
                            onSeekBackward: () => cubit.seekBackward(10),
                            onSeekForward: () => cubit.seekForward(10),
                          ),
                          const SizedBox(height: 20),
                          // Speed Control
                          AudioSpeedControl(
                            currentSpeed: cubit.currentSpeed,
                            onSpeedChanged: (speed) => cubit.setSpeed(speed),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
