import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Singleton manager لإدارة كل الفيديوهات في Reels
/// بيضمن إن فيديو واحد بس يشتغل في نفس الوقت
class VideoPlayerManager {
  static final VideoPlayerManager _instance = VideoPlayerManager._internal();
  factory VideoPlayerManager() => _instance;
  VideoPlayerManager._internal();

  // Boolean للتحكم في حالة الـ reels - هل احنا جوا الـ reels ولا لأ
  bool _isInReelsView = false;

  // الفيديو اللي شغال حالياً
  VideoPlayerController? _currentVideoController;
  YoutubePlayerController? _currentYoutubeController;
  String? _currentPlayingId;

  // حفظ آخر position لكل فيديو
  final Map<String, Duration> _savedPositions = {};

  // تتبع كل الـ controllers اللي اتعملت للتدمير الكامل
  final Set<VideoPlayerController> _allVideoControllers = {};
  final Set<YoutubePlayerController> _allYoutubeControllers = {};

  /// Register controllers created outside the manager
  void registerVideoController(VideoPlayerController controller) {
    _allVideoControllers.add(controller);
  }

  void unregisterVideoController(VideoPlayerController controller) {
    _allVideoControllers.remove(controller);
  }

  void registerYoutubeController(YoutubePlayerController controller) {
    _allYoutubeControllers.add(controller);
  }

  void unregisterYoutubeController(YoutubePlayerController controller) {
    _allYoutubeControllers.remove(controller);
  }

  /// Pause and mute all controllers without disposing (for tab switches)
  void pauseAndMuteAll() {
    debugPrint('⏸️ MANAGER: Pausing and muting all controllers');

    // Pause/mute all regular video controllers
    for (final controller in _allVideoControllers.toList()) {
      try {
        if (controller.value.isInitialized) {
          controller.pause();
          controller.setVolume(0.0);
        }
      } catch (e) {
        debugPrint('Error pausing/muting video controller: $e');
      }
    }

    // Pause/mute all YouTube controllers
    for (final controller in _allYoutubeControllers.toList()) {
      try {
        controller.pause();
        // Ensure audio is fully muted
        try {
          controller.mute();
        } catch (_) {}
        // Reset to guarantee stop
        try {
          controller.reset();
        } catch (_) {}
      } catch (e) {
        debugPrint('Error pausing YouTube controller: $e');
      }
    }

    // Also pause current ones, if any
    try {
      if (_currentVideoController != null &&
          _currentVideoController!.value.isInitialized) {
        _currentVideoController!.pause();
        _currentVideoController!.setVolume(0.0);
      }
    } catch (e) {
      debugPrint('Error pausing current video: $e');
    }

    try {
      _currentYoutubeController?.pause();
      try {
        _currentYoutubeController?.mute();
      } catch (_) {}
      try {
        _currentYoutubeController?.reset();
      } catch (_) {}
    } catch (e) {
      debugPrint('Error pausing current YouTube: $e');
    }

    _currentPlayingId = null;
  }

  /// تشغيل فيديو جديد (بيوقف أي فيديو تاني شغال)
  Future<void> playVideo({
    required String reelId,
    required VideoPlayerController controller,
  }) async {
    debugPrint('▶️ MANAGER: Play video request for $reelId (IsInReels: $_isInReelsView)');

    // إذا لم نكن في الـ reels view، امنع التشغيل
    if (!_isInReelsView) {
      debugPrint('🚫 MANAGER: Not in reels view - blocking video playback');
      return;
    }

    // لو نفس الفيديو وشغال، متعملش حاجة
    if (_currentPlayingId == reelId &&
        _currentVideoController == controller &&
        controller.value.isPlaying) {
      debugPrint('▶️ MANAGER: Same video already playing, skipping');
      return;
    }

    // لو نفس الفيديو بس موقوف، كمل من نفس المكان
    if (_currentPlayingId == reelId && _currentVideoController == controller) {
      if (controller.value.isInitialized) {
        // استرجع الـ position المحفوظ
        final savedPosition = getSavedPosition(reelId);
        if (savedPosition != null && savedPosition > Duration.zero) {
          debugPrint('▶️ MANAGER: Resuming from ${savedPosition.inSeconds}s');
          await controller.seekTo(savedPosition);
          await Future.delayed(const Duration(milliseconds: 200));
        }

        await controller.setVolume(1.0);
        await controller.play();
        debugPrint('▶️ MANAGER: Resumed same video');
      }
      return;
    }

    // أوقف أي فيديو تاني شغال
    await _pauseAll();

    // شغل الفيديو الجديد
    _currentVideoController = controller;
    _currentPlayingId = reelId;
    _currentYoutubeController = null;

    // أضف الـ controller للتتبع
    _allVideoControllers.add(controller);

    if (controller.value.isInitialized) {
      // استرجع الـ position المحفوظ للفيديو الجديد
      final savedPosition = getSavedPosition(reelId);
      if (savedPosition != null && savedPosition > Duration.zero) {
        debugPrint(
          '▶️ MANAGER: Starting new video from ${savedPosition.inSeconds}s',
        );
        await controller.seekTo(savedPosition);
        await Future.delayed(const Duration(milliseconds: 200));
      }

      await controller.setVolume(1.0);
      await controller.play();
      debugPrint('▶️ MANAGER: Started new video');
    }
  }

  /// تشغيل YouTube video
  void playYoutubeVideo({
    required String reelId,
    required YoutubePlayerController controller,
  }) {
    debugPrint('▶️ MANAGER: Play YouTube request for $reelId (IsInReels: $_isInReelsView)');

    // إذا لم نكن في الـ reels view، امنع التشغيل
    if (!_isInReelsView) {
      debugPrint('🚫 MANAGER: Not in reels view - blocking YouTube playback');
      return;
    }

    // لو نفس الفيديو وشغال، متعملش حاجة
    if (_currentPlayingId == reelId &&
        _currentYoutubeController == controller &&
        controller.value.isPlaying) {
      debugPrint('▶️ MANAGER: Same YouTube already playing, skipping');
      return;
    }

    // لو نفس الفيديو بس موقوف، كمل من نفس المكان
    if (_currentPlayingId == reelId &&
        _currentYoutubeController == controller) {
      try {
        // استرجع الـ position المحفوظ
        final savedPosition = getSavedPosition(reelId);
        if (savedPosition != null && savedPosition > Duration.zero) {
          debugPrint(
            '▶️ MANAGER: Resuming YouTube from ${savedPosition.inSeconds}s',
          );
          controller.seekTo(savedPosition);
        }

        controller.play();
        debugPrint('▶️ MANAGER: Resumed YouTube');
      } catch (e) {
        debugPrint('Error resuming YouTube: $e');
      }
      return;
    }

    // أوقف أي فيديو تاني
    _pauseAll();

    // شغل YouTube video
    _currentYoutubeController = controller;
    _currentPlayingId = reelId;
    _currentVideoController = null;

    // أضف الـ YouTube controller للتتبع
    _allYoutubeControllers.add(controller);

    try {
      // استرجع الـ position المحفوظ للفيديو الجديد
      final savedPosition = getSavedPosition(reelId);

      if (!controller.value.isReady) {
        // Wait for controller to be ready
        Future.delayed(const Duration(milliseconds: 500), () {
          try {
            // لا تشغّل لو خرجنا من الـ Reels أو تغير الـ controller الحالي
            if (!_isInReelsView ||
                _currentYoutubeController != controller ||
                _currentPlayingId != reelId) {
              debugPrint('🚫 MANAGER: Skip delayed YouTube play (not in Reels or controller changed)');
              return;
            }
            if (savedPosition != null && savedPosition > Duration.zero) {
              debugPrint(
                '▶️ MANAGER: Starting YouTube from ${savedPosition.inSeconds}s',
              );
              controller.seekTo(savedPosition);
            }
            try {
              controller.unMute();
            } catch (_) {}
            controller.play();
            debugPrint('▶️ MANAGER: Started YouTube after delay');
          } catch (e) {
            debugPrint('Error playing YouTube after delay: $e');
          }
        });
      } else {
        // لا تشغّل لو خرجنا من الـ Reels أو تغير الـ controller الحالي
        if (!_isInReelsView ||
            _currentYoutubeController != controller ||
            _currentPlayingId != reelId) {
          debugPrint('🚫 MANAGER: Skip immediate YouTube play (not in Reels or controller changed)');
          return;
        }
        if (savedPosition != null && savedPosition > Duration.zero) {
          debugPrint(
            '▶️ MANAGER: Starting YouTube from ${savedPosition.inSeconds}s',
          );
          controller.seekTo(savedPosition);
        }
        try {
          controller.unMute();
        } catch (_) {}
        controller.play();
        debugPrint('▶️ MANAGER: Started YouTube immediately');
      }
    } catch (e) {
      debugPrint('Error playing YouTube: $e');
    }
  }

  /// إيقاف كل الفيديوهات (internal method)
  Future<void> _pauseAll() async {
    if (_currentVideoController != null && _currentPlayingId != null) {
      try {
        if (_currentVideoController!.value.isInitialized) {
          // احفظ الـ position الحالي قبل ما نوقف
          final currentPosition = _currentVideoController!.value.position;
          // احفظ الـ position حتى لو كان zero (مهم للـ seeking)
          savePosition(_currentPlayingId!, currentPosition);
          debugPrint(
            '🛑 MANAGER: Saved position ${currentPosition.inSeconds}s for $_currentPlayingId before pauseAll',
          );

          await _currentVideoController!.pause();
          await _currentVideoController!.setVolume(0.0);
        }
      } catch (e) {
        debugPrint('Error pausing video: $e');
      }
    }

    if (_currentYoutubeController != null && _currentPlayingId != null) {
      try {
        // للـ YouTube مش نقدر نجيب الـ position بسهولة، بس نحفظ آخر معلوم
        _currentYoutubeController!.pause();
        debugPrint('🛑 MANAGER: Paused YouTube $_currentPlayingId');
      } catch (e) {
        debugPrint('Error pausing YouTube: $e');
      }
    }

    _currentPlayingId = null;
  }

  /// إيقاف فيديو معين (بدون reset position)
  Future<void> pauseVideo(String reelId) async {
    if (_currentPlayingId == reelId) {
      debugPrint('🛑 MANAGER: Pausing video $reelId');

      // Pause بس بدون clear الـ ID عشان يكمل من نفس المكان
      if (_currentVideoController != null) {
        try {
          if (_currentVideoController!.value.isInitialized) {
            // احفظ الـ position الحالي قبل ما نوقف
            final currentPosition = _currentVideoController!.value.position;
            // احفظ الـ position حتى لو كان zero
            savePosition(reelId, currentPosition);

            await _currentVideoController!.pause();
            debugPrint(
              '🛑 MANAGER: Video paused at ${currentPosition.inSeconds}s',
            );
          }
        } catch (e) {
          debugPrint('Error pausing video: $e');
        }
      }

      if (_currentYoutubeController != null) {
        try {
          _currentYoutubeController!.pause();
          debugPrint('🛑 MANAGER: YouTube paused');
        } catch (e) {
          debugPrint('Error pausing YouTube: $e');
        }
      }
      // مش بنعمل clear للـ _currentPlayingId عشان نفتكر الفيديو
    }
  }

  /// إيقاف كل الفيديوهات (public API)
  Future<void> stopAll() async {
    debugPrint('🛑 MANAGER STOP ALL: Stopping all videos immediately');

    // أوقف كل الفيديوهات فوراً
    if (_currentVideoController != null) {
      try {
        // احفظ الـ position قبل الإيقاف
        if (_currentVideoController!.value.isInitialized &&
            _currentPlayingId != null) {
          final currentPosition = _currentVideoController!.value.position;
          savePosition(_currentPlayingId!, currentPosition);
          debugPrint(
            '🛑 MANAGER: Saved position ${currentPosition.inSeconds}s before stopping',
          );
        }

        await _currentVideoController!.pause();
        await _currentVideoController!.setVolume(0.0);
        debugPrint('🛑 MANAGER: Video stopped and muted');
      } catch (e) {
        debugPrint('Error stopping video: $e');
      }
    }

    if (_currentYoutubeController != null) {
      try {
        _currentYoutubeController!.pause();
        debugPrint('🛑 MANAGER: YouTube stopped');
      } catch (e) {
        debugPrint('Error stopping YouTube: $e');
      }
    }

    // امسح الـ current playing ID علشان ميفضلش يشتغل
    _currentPlayingId = null;
    _currentVideoController = null;
    _currentYoutubeController = null;
  }

  /// إيقاف فوري وقوي لكل الفيديوهات (للاستخدام عند الخروج من التطبيق)
  void forceStopAll() {
    debugPrint(
      '🚨 MANAGER FORCE STOP: DESTROYING ALL ${_allVideoControllers.length} video + ${_allYoutubeControllers.length} YouTube controllers',
    );

    // تدمير كل الـ video controllers
    for (final controller in _allVideoControllers.toList()) {
      try {
        controller.pause();
        controller.setVolume(0.0);
        controller.dispose();
        debugPrint('🚨 MANAGER: Video controller DISPOSED');
      } catch (e) {
        debugPrint('Error disposing video controller: $e');
      }
    }

    // تدمير كل الـ YouTube controllers
    for (final controller in _allYoutubeControllers.toList()) {
      try {
        controller.pause();
        controller.reset();
        debugPrint('🚨 MANAGER: YouTube controller RESET');
      } catch (e) {
        debugPrint('Error resetting YouTube controller: $e');
      }
    }

    // تدمير الـ current controllers إضافياً للأمان
    try {
      if (_currentVideoController != null) {
        _currentVideoController!.pause();
        _currentVideoController!.setVolume(0.0);
        _currentVideoController!.dispose();
        debugPrint('🚨 MANAGER: Current video controller DISPOSED');
      }

      if (_currentYoutubeController != null) {
        _currentYoutubeController!.pause();
        _currentYoutubeController!.reset();
        debugPrint('🚨 MANAGER: Current YouTube controller RESET');
      }
    } catch (e) {
      debugPrint('Error disposing current controllers: $e');
    }

    // امسح كل شيء فوراً
    _allVideoControllers.clear();
    _allYoutubeControllers.clear();
    _currentPlayingId = null;
    _currentVideoController = null;
    _currentYoutubeController = null;

    debugPrint(
      '🚨 MANAGER: ALL CONTROLLERS DESTROYED - TOTAL CLEANUP COMPLETE',
    );
  }

  /// Check if video is playing
  bool isPlaying(String reelId) {
    return _currentPlayingId == reelId;
  }

  /// Save position for a video
  void savePosition(String reelId, Duration position) {
    if (reelId.isEmpty) {
      debugPrint('⚠️ MANAGER SAVE: Empty reelId, skipping save');
      return;
    }

    _savedPositions[reelId] = position;
    debugPrint(
      '🗄️ MANAGER SAVE: ReelID=$reelId, Position=${position.inSeconds}s, MapSize=${_savedPositions.length}',
    );

    // تنظيف المواضع القديمة كل فترة
    _cleanupOldPositions();
  }

  /// Get saved position for a video
  Duration? getSavedPosition(String reelId) {
    final position = _savedPositions[reelId];
    debugPrint('🗄️ MANAGER GET: ReelID=$reelId');
    debugPrint(
      '🗄️ MANAGER GET: Map has ${_savedPositions.length} entries: ${_savedPositions.keys.take(3).join(", ")}...',
    );
    debugPrint('🗄️ MANAGER GET: Returning ${position?.inSeconds ?? "NULL"}');
    return position;
  }

  /// Clear saved position for a video
  void clearPosition(String reelId) {
    debugPrint('🗑️ MANAGER CLEAR: Removing position for ReelID=$reelId');
    _savedPositions.remove(reelId);
  }

  /// Clear old positions to prevent memory leaks (keep only last 50)
  void _cleanupOldPositions() {
    if (_savedPositions.length > 50) {
      final keys = _savedPositions.keys.toList();
      final keysToRemove = keys.take(_savedPositions.length - 50);
      for (final key in keysToRemove) {
        _savedPositions.remove(key);
      }
      debugPrint(
        '🧹 MANAGER CLEANUP: Removed ${keysToRemove.length} old positions',
      );
    }
  }

  /// تحديد إننا دخلنا الـ reels view
  void enterReelsView() {
    _isInReelsView = true;
    debugPrint('🎬 REELS STATE: Entered Reels View');
  }

  /// تحديد إننا خرجنا من الـ reels view
  void exitReelsView() {
    _isInReelsView = false;
    debugPrint('🚪 REELS STATE: Exited Reels View - Pausing and muting all');
    // إيقاف وميوت بدون dispose لتفادي مشاكل keepAlive
    pauseAndMuteAll();
  }

  /// التحقق من إننا في الـ reels view
  bool get isInReelsView => _isInReelsView;

  /// قتل كل الفيديوهات فوراً - بسيط وفعال ومحدث
  void killAllVideos() {
    debugPrint('💀 KILL ALL VIDEOS: Destroying everything NOW (IsInReels: $_isInReelsView)');

    // إذا لم نكن في الـ reels، امنع أي تشغيل جديد
    if (!_isInReelsView) {
      debugPrint('💀 KILL ALL VIDEOS: Not in reels view - blocking future playback');
    }

    // تدمير كل الـ video controllers
    for (final controller in _allVideoControllers.toList()) {
      try {
        if (controller.value.isInitialized) {
          controller.pause();
          controller.setVolume(0.0);
        }
        controller.dispose();
        debugPrint('💀 Video controller disposed');
      } catch (e) {
        debugPrint('Error disposing video controller: $e');
      }
    }

    // تدمير كل الـ YouTube controllers
    for (final controller in _allYoutubeControllers.toList()) {
      try {
        controller.pause();
        controller.reset();
        controller.dispose();
        debugPrint('💀 YouTube controller DISPOSED');
      } catch (e) {
        debugPrint('Error resetting YouTube controller: $e');
      }
    }

    // تدمير الـ current controllers
    try {
      if (_currentVideoController != null) {
        if (_currentVideoController!.value.isInitialized) {
          _currentVideoController!.pause();
          _currentVideoController!.setVolume(0.0);
        }
        _currentVideoController!.dispose();
        debugPrint('💀 Current video controller disposed');
      }
    } catch (e) {
      debugPrint('Error disposing current video controller: $e');
    }

    try {
      if (_currentYoutubeController != null) {
        _currentYoutubeController!.pause();
        _currentYoutubeController!.reset();
        _currentYoutubeController!.dispose();
        debugPrint('💀 Current YouTube controller DISPOSED');
      }
    } catch (e) {
      debugPrint('Error resetting current YouTube controller: $e');
    }

    // امسح كل شيء فوراً
    _allVideoControllers.clear();
    _allYoutubeControllers.clear();
    _currentVideoController = null;
    _currentYoutubeController = null;
    _currentPlayingId = null;
    _savedPositions.clear();

    debugPrint('💀 KILL ALL VIDEOS: Everything destroyed completely');
  }

  /// Dispose كل الـ controllers عند الخروج من Reels
  Future<void> disposeAll() async {
    killAllVideos();
  }
}
