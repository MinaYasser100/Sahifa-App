import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

part 'video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController? _controller;
  // Indicates if this cubit owns the controller and should dispose it
  bool _ownsController = true;

  /// If [preloadedController] is provided it will be used instead of creating
  /// a new controller. When using a preloaded controller this cubit will
  /// not dispose it (ownership stays with the preload cache).
  VideoPlayerCubit({VideoPlayerController? preloadedController})
    : super(VideoPlayerInitial()) {
    if (preloadedController != null) {
      _controller = preloadedController;
      _ownsController = false;
      // make sure it's looping and listen for runtime errors
      try {
        _controller!.setLooping(true);
      } catch (_) {}
      _controller!.addListener(() {
        if (_controller!.value.hasError) {
          final error = _controller!.value.errorDescription;
          emit(VideoPlayerError(message: error ?? 'Video playback error'));
        }
      });

      // If already initialized, emit ready immediately
      if (_controller!.value.isInitialized) {
        emit(VideoPlayerReady(isPlaying: false));
      } else {
        // if not initialized, keep initial state; initializeVideo will handle
      }
    }
  }

  VideoPlayerController? get controller => _controller;

  Future<void> initializeVideo(String videoUrl) async {
    emit(VideoPlayerLoading());

    try {
      // If a controller was preloaded and attached, skip creating a new one.
      if (_controller == null) {
        // للفيديوهات Local
        if (videoUrl.startsWith('assets/')) {
          _controller = VideoPlayerController.asset(videoUrl);
        } else {
          // للفيديوهات من Backend (URL)
          _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        }

        // mark that this cubit owns the controller and should dispose it
        _ownsController = true;

        await _controller!.initialize();

        // التأكد من إن الـ controller اتعمله initialize صح
        if (!_controller!.value.isInitialized) {
          throw Exception('Failed to initialize video player');
        }

        _controller!.setLooping(true);

        // الاستماع للأخطاء اللي بتحصل أثناء التشغيل
        _controller!.addListener(() {
          if (_controller!.value.hasError) {
            final error = _controller!.value.errorDescription;
            emit(VideoPlayerError(message: error ?? 'Video playback error'));
          }
        });
      } else {
        // controller already provided (preloaded): ensure looping and listener
        try {
          _controller!.setLooping(true);
        } catch (_) {}
      }

      emit(VideoPlayerReady(isPlaying: false));
    } catch (e) {
      if (_ownsController) {
        _controller?.dispose();
        _controller = null;
      }

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
    if (_ownsController) {
      _controller?.dispose();
    }
    return super.close();
  }
}
