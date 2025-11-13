import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sahifa/features/reels/manager/video_player_cubit/video_player_state.dart';
import 'package:sahifa/features/reels/manager/video_player_manager.dart';

import 'dart:async';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  final bool _isYoutube;
  final VideoPlayerManager _manager = VideoPlayerManager();
  String _reelId = '';
  bool _isSeeking = false;
  Timer? _positionTimer;
  Duration _lastKnownPosition = Duration.zero;
  Duration _accumulatedTime = Duration.zero;
  DateTime? _lastPlayTime;

  VideoPlayerCubit({required bool isYoutube})
    : _isYoutube = isYoutube,
      super(VideoPlayerInitial());

  Future<void> initialize({
    required String reelId,
    required String videoUrl,
    VideoPlayerController? videoController,
    YoutubePlayerController? youtubeController,
  }) async {
    _reelId = reelId;
    try {
      emit(VideoPlayerLoading());

      if (_isYoutube) {
        _youtubeController = youtubeController;
        _youtubeController?.addListener(_youtubeListener);
        emit(
          const VideoPlayerReady(
            isPlaying: false,
            position: Duration.zero,
            duration: Duration.zero,
          ),
        );
      } else {
        _videoController = videoController;
        _videoController?.addListener(_videoListener);
        _startPositionTimer();
        emit(
          VideoPlayerReady(
            isPlaying: false,
            position: _videoController?.value.position ?? Duration.zero,
            duration: _videoController?.value.duration ?? Duration.zero,
          ),
        );
      }
    } catch (e) {
      emit(VideoPlayerError(message: 'Failed to initialize: $e'));
    }
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_videoController != null &&
          _videoController!.value.isInitialized &&
          _videoController!.value.isPlaying &&
          !_isSeeking &&
          _lastPlayTime != null) {
        
        // احسب الوقت المنقضي منذ آخر play
        final now = DateTime.now();
        final elapsedSincePlay = now.difference(_lastPlayTime!);
        final currentPosition = _accumulatedTime + elapsedSincePlay;

        _lastKnownPosition = currentPosition;
        _manager.savePosition(_reelId, currentPosition);

        log(
          '💾 Position tracking: ${currentPosition.inSeconds}s (accumulated: ${_accumulatedTime.inSeconds}s, current: ${elapsedSincePlay.inSeconds}s)',
        );
      }
    });
  }

  void _videoListener() {
    if (_isSeeking || _videoController == null || isClosed) return;

    final currentState = state;
    if (currentState is VideoPlayerReady) {
      final newPosition = _videoController!.value.position;
      final isPlaying = _videoController!.value.isPlaying;

      _lastKnownPosition = newPosition;

      if (currentState.isPlaying != isPlaying ||
          (newPosition - currentState.position).abs() >
              const Duration(milliseconds: 500)) {
        emit(
          VideoPlayerReady(
            isPlaying: isPlaying,
            position: newPosition,
            duration: _videoController!.value.duration,
          ),
        );
      }
    }
  }

  void _youtubeListener() {
    if (_youtubeController != null && !isClosed) {
      final currentState = state;
      if (currentState is VideoPlayerReady) {
        final isPlaying = _youtubeController!.value.isPlaying;
        if (currentState.isPlaying != isPlaying) {
          emit(
            VideoPlayerReady(
              isPlaying: isPlaying,
              position: currentState.position,
              duration: currentState.duration,
            ),
          );
        }
      }
    }
  }

  Future<void> play() async {
    final currentState = state;
    if (currentState is! VideoPlayerReady) return;

    try {
      if (_isYoutube && _youtubeController != null) {
        final savedPosition = _manager.getSavedPosition(_reelId);
        log(
          '▶️ YouTube Play - ReelID: $_reelId, Saved position: ${savedPosition?.inSeconds ?? 0}s',
        );

        if (savedPosition != null && savedPosition > Duration.zero) {
          try {
            _youtubeController!.seekTo(savedPosition);
            await Future.delayed(const Duration(milliseconds: 500));
            log('⏩ YouTube seeked to: ${savedPosition.inSeconds}s');
          } catch (e) {
            log('❌ YouTube seek error: $e');
          }
        }

        _youtubeController!.play();
        emit(
          VideoPlayerReady(
            isPlaying: true,
            position: savedPosition ?? currentState.position,
            duration: currentState.duration,
          ),
        );
      } else if (_videoController != null &&
          _videoController!.value.isInitialized) {
        final savedPosition = _manager.getSavedPosition(_reelId);
        log(
          '▶️ Play called - ReelID: $_reelId, Saved position: ${savedPosition?.inSeconds ?? 0}s',
        );

        if (savedPosition != null && savedPosition > Duration.zero) {
          _isSeeking = true;
          try {
            // اعمل seek للـ position المحفوظ
            await _videoController!.seekTo(savedPosition);
            await Future.delayed(const Duration(milliseconds: 300));

            _lastKnownPosition = savedPosition;
            _accumulatedTime = savedPosition; // حدث الوقت المتراكم
            log('⏩ Seeked to: ${savedPosition.inSeconds}s');
          } catch (e) {
            log('❌ Seek error: $e - playing from start');
            _lastKnownPosition = Duration.zero;
            _accumulatedTime = Duration.zero;
          } finally {
            _isSeeking = false;
          }
        } else {
          log('▶️ Playing from start (no saved position)');
          _lastKnownPosition = Duration.zero;
          _accumulatedTime = Duration.zero;
        }

        // ابدأ تتبع الوقت وشغل الفيديو
        _lastPlayTime = DateTime.now();
        await _videoController!.play();

        log('✅ Playing from: ${_lastKnownPosition.inSeconds}s');

        final actualPosition = savedPosition ?? _lastKnownPosition;
        emit(
          VideoPlayerReady(
            isPlaying: true,
            position: actualPosition,
            duration: currentState.duration,
          ),
        );
      }
    } catch (e) {
      emit(VideoPlayerError(message: 'Failed to play: $e'));
    }
  }

  Future<void> pause() async {
    final currentState = state;
    if (currentState is! VideoPlayerReady) return;

    try {
      late Duration currentPosition;

      if (_isYoutube && _youtubeController != null) {
        try {
          currentPosition = _lastKnownPosition;
          _youtubeController!.pause();
          log(
            '🛑 Paused YouTube at: ${currentPosition.inSeconds}s (Reel: $_reelId)',
          );
        } catch (e) {
          currentPosition = currentState.position;
          log('❌ YouTube pause error: $e');
        }
      } else if (_videoController != null &&
          _videoController!.value.isInitialized) {
        // احسب الوقت المنقضي منذ آخر play
        if (_lastPlayTime != null) {
          final now = DateTime.now();
          final elapsedSincePlay = now.difference(_lastPlayTime!);
          currentPosition = _accumulatedTime + elapsedSincePlay;
          
          // حدث الوقت المتراكم للمرة الجاية
          _accumulatedTime = currentPosition;
          _lastPlayTime = null; // أوقف تتبع الوقت
        } else {
          currentPosition = _lastKnownPosition;
        }
        
        _lastKnownPosition = currentPosition;

        await _videoController!.pause();
        log(
          '🛑 Paused at: ${currentPosition.inSeconds}s (accumulated: ${_accumulatedTime.inSeconds}s) (Reel: $_reelId)',
        );
      } else {
        currentPosition = currentState.position;
      }

      _manager.savePosition(_reelId, currentPosition);

      emit(
        VideoPlayerReady(
          isPlaying: false,
          position: currentPosition,
          duration: currentState.duration,
        ),
      );
    } catch (e) {
      emit(VideoPlayerError(message: 'Failed to pause: $e'));
    }
  }

  Future<void> togglePlayPause() async {
    final currentState = state;
    if (currentState is VideoPlayerReady) {
      if (currentState.isPlaying) {
        await pause();
      } else {
        await play();
      }
    }
  }

  Future<void> seekTo(Duration position) async {
    if (_videoController != null) {
      await _videoController!.seekTo(position);
      _manager.savePosition(_reelId, position);
    }
  }

  @override
  Future<void> close() {
    // أوقف كل حاجة فوراً
    _positionTimer?.cancel();
    _lastPlayTime = null;
    
    // أوقف الفيديو فوراً قبل الحفظ
    try {
      _videoController?.pause();
      _videoController?.setVolume(0.0);
      _youtubeController?.pause();
    } catch (e) {
      log('❌ Error stopping video on close: $e');
    }
    
    // احفظ الموضع النهائي
    if (_videoController != null &&
        _videoController!.value.isInitialized &&
        _reelId.isNotEmpty) {
      final finalPosition = _lastKnownPosition;
      _manager.savePosition(_reelId, finalPosition);
      log(
        '💾 Final position saved on close: ${finalPosition.inSeconds}s for $_reelId',
      );
    }

    // نضف الـ listeners والـ controllers
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _youtubeController?.removeListener(_youtubeListener);
    _youtubeController?.dispose();
    
    return super.close();
  }
}
