import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

part 'video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController? _controller;

  VideoPlayerCubit() : super(VideoPlayerInitial());

  VideoPlayerController? get controller => _controller;

  Future<void> initializeVideo(String videoUrl) async {
    emit(VideoPlayerLoading());

    try {
      // للفيديوهات Local
      if (videoUrl.startsWith('assets/')) {
        _controller = VideoPlayerController.asset(videoUrl);
      } else {
        // للفيديوهات من Backend (URL)
        _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      }

      await _controller!.initialize();
      _controller!.setLooping(true);

      emit(VideoPlayerReady(isPlaying: false));
    } catch (e) {
      emit(VideoPlayerError(message: 'Error initializing video: $e'));
    }
  }

  void play({bool resetManualPause = false}) {
    if (isClosed) return;
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.play();
      emit(
        VideoPlayerReady(
          isPlaying: true,
          isManuallyPaused: resetManualPause
              ? false
              : (state is VideoPlayerReady
                    ? (state as VideoPlayerReady).isManuallyPaused
                    : false),
        ),
      );
    }
  }

  void pause({bool isManual = false}) {
    if (isClosed) return;
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.pause();
      emit(VideoPlayerReady(isPlaying: false, isManuallyPaused: isManual));
    }
  }

  void togglePlayPause() {
    if (isClosed) return;
    final currentState = state;
    if (currentState is VideoPlayerReady) {
      if (currentState.isPlaying) {
        pause(isManual: true); // المستخدم عمل pause يدوي
      } else {
        play(
          resetManualPause: true,
        ); // المستخدم عمل play يدوي، نلغي الـ manual pause
      }
    }
  }

  // للـ auto play/pause من الـ VisibilityDetector
  void autoPlay() {
    final currentState = state;
    if (currentState is VideoPlayerReady && !currentState.isManuallyPaused) {
      play();
    }
  }

  void autoPause() {
    final currentState = state;
    // بس نوقف الفيديو لو مش manually paused
    if (currentState is VideoPlayerReady && !currentState.isManuallyPaused) {
      pause(isManual: false);
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
