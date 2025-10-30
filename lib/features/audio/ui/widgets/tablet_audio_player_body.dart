import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/features/audio/manager/audio_player_cubit/audio_player_cubit.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_cover_image.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_info_header.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_player_controls.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_progress_bar.dart';
import 'package:sahifa/features/audio/ui/widgets/audio_speed_control.dart';

class TabletAudioPlayerBody extends StatelessWidget {
  final AudioItemModel audioItem;

  const TabletAudioPlayerBody({super.key, required this.audioItem});

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
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Row(
            children: [
              // Left Side - Cover Image (Larger)
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AudioCoverImage(
                        imageUrl: audioItem.thumbnailUrl,
                        audioId: audioItem.id ?? '',
                      ),
                    ),
                    const SizedBox(height: 40),
                    AudioInfoHeader(
                      title: audioItem.title,
                      authorName: audioItem.authorName,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(width: 80),
              // Right Side - Controls
              Expanded(
                flex: 2,
                child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
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

                    return FadeInRight(
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Progress Bar
                          AudioProgressBar(
                            position: position,
                            duration: duration,
                            onSeek: (newPosition) => cubit.seekTo(newPosition),
                            formatDuration: cubit.formatDuration,
                          ),
                          const SizedBox(height: 50),
                          // Control Buttons
                          AudioPlayerControls(
                            isPlaying: isPlaying,
                            isBuffering: isBuffering,
                            onPlayPause: () => cubit.togglePlayPause(),
                            onSeekBackward: () => cubit.seekBackward(10),
                            onSeekForward: () => cubit.seekForward(10),
                          ),
                          const SizedBox(height: 50),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
