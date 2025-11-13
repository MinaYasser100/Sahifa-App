import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:sahifa/core/model/reels_model/reel.dart';
import 'package:sahifa/features/reels/manager/video_player_cubit/video_player_cubit.dart';
import 'package:sahifa/features/reels/manager/video_player_cubit/video_player_state.dart';
import 'package:sahifa/features/reels/utils/video_url_helper.dart';
import 'package:sahifa/features/reels/manager/video_player_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Video player بسيط للريلز مع Cubit
class ReelVideoPlayer extends StatefulWidget {
  final Reel reel;
  final bool shouldPlay;
  final Function(VoidCallback)? onToggleReady;

  const ReelVideoPlayer({
    super.key,
    required this.reel,
    required this.shouldPlay,
    this.onToggleReady,
  });

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  bool _isYoutube = false;
  late final VideoPlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _isYoutube = VideoUrlHelper.isYouTubeUrl(widget.reel.videoUrl);
    _cubit = VideoPlayerCubit(isYoutube: _isYoutube);
    _initializePlayer();

    // Pass toggle function to parent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onToggleReady?.call(() => _cubit.togglePlayPause());
    });
  }

  @override
  void didUpdateWidget(ReelVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // لو اتغير ال shouldPlay فقط
    if (widget.shouldPlay != oldWidget.shouldPlay) {
      debugPrint(
        '📱 didUpdateWidget - shouldPlay changed to: ${widget.shouldPlay} (Reel: ${widget.reel.id})',
      );

      // انتظر frame واحد قبل ما نعمل play/pause علشان نتأكد إن كل حاجة جاهزة
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (widget.shouldPlay) {
            _cubit.play();
          } else {
            _cubit.pause();
            // تأكد من إيقاف الصوت فوراً
            if (_videoController != null) {
              _videoController!.setVolume(0.0);
            }
            debugPrint('🛑 VIDEO PLAYER: shouldPlay=false, video muted');
          }
        }
      });
    }
  }

  Future<void> _initializePlayer() async {
    final videoUrl = widget.reel.videoUrl;

    if (_isYoutube) {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false, // دايماً false عشان نتحكم احنا في الـ play
            mute: false,
            loop: true,
            hideControls: true,
          ),
        );

        await _cubit.initialize(
          reelId: widget.reel.id,
          videoUrl: videoUrl,
          youtubeController: _youtubeController,
        );

        if (mounted && widget.shouldPlay) {
          // خلي delay أطول عشان يتأكد إن كل حاجة جاهزة
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _cubit.play();
          });
        }
      }
    } else {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _videoController!.initialize();
      await _videoController!.setLooping(true);

      await _cubit.initialize(
        reelId: widget.reel.id,
        videoUrl: videoUrl,
        videoController: _videoController,
      );

      if (mounted && widget.shouldPlay) {
        // خلي delay أطول عشان يتأكد إن كل حاجة جاهزة
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _cubit.play();
        });
      }
    }
  }

  @override
  void dispose() {
    debugPrint('🚮 VIDEO PLAYER: Disposing reel ${widget.reel.id}');
    
    // أوقف الـ cubit
    _cubit.pause();
    _cubit.close();
    
    // تدمير الـ controllers محلياً
    try {
      _videoController?.pause();
      _videoController?.setVolume(0.0);
      _videoController?.dispose();
    } catch (e) {
      // تجاهل الأخطاء
    }
    
    try {
      _youtubeController?.pause();
      _youtubeController?.reset();
    } catch (e) {
      // تجاهل الأخطاء
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // لو مش في الـ Reels view، لا تركّب أي player وأوقف فوراً
    final isActive = VideoPlayerManager().isInReelsView;
    if (!isActive || !widget.shouldPlay) {
      // تأكد من الإيقاف
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _cubit.pause();
        }
      });
      return Container(color: Colors.black);
    }

    // Background سودا دايماً
    return Container(
      color: Colors.black,
      child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is VideoPlayerLoading || state is VideoPlayerInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is VideoPlayerError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state is VideoPlayerReady) {
            if (_isYoutube && _youtubeController != null) {
              // عندما لا يجب أن يعمل الفيديو، لا نركّب الـ YoutubePlayer إطلاقاً لمنع أي صوت
              if (!widget.shouldPlay) {
                return Container(color: Colors.black);
              }

              return Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: false,
                    aspectRatio: 9 / 16,
                    onReady: () {
                      try {
                        _youtubeController!.unMute();
                      } catch (_) {}
                    },
                  ),
                ),
              );
            }

            if (_videoController != null) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                  // Play icon when paused
                  if (!state.isPlaying)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                ],
              );
            }
          }

          return const SizedBox();
        },
      ),
    );
  }
}
