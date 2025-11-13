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

  // الفيديو اللي شغال حالياً
  VideoPlayerController? _currentVideoController;
  YoutubePlayerController? _currentYoutubeController;
  String? _currentPlayingId;

  // حفظ آخر position لكل فيديو
  final Map<String, Duration> _savedPositions = {};

  /// تشغيل فيديو جديد (بيوقف أي فيديو تاني شغال)
  Future<void> playVideo({
    required String reelId,
    required VideoPlayerController controller,
  }) async {
    debugPrint('▶️ MANAGER: Play video request for $reelId');
    
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

    if (controller.value.isInitialized) {
      // استرجع الـ position المحفوظ للفيديو الجديد
      final savedPosition = getSavedPosition(reelId);
      if (savedPosition != null && savedPosition > Duration.zero) {
        debugPrint('▶️ MANAGER: Starting new video from ${savedPosition.inSeconds}s');
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
    debugPrint('▶️ MANAGER: Play YouTube request for $reelId');
    
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
          debugPrint('▶️ MANAGER: Resuming YouTube from ${savedPosition.inSeconds}s');
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

    try {
      // استرجع الـ position المحفوظ للفيديو الجديد
      final savedPosition = getSavedPosition(reelId);
      
      if (!controller.value.isReady) {
        // Wait for controller to be ready
        Future.delayed(const Duration(milliseconds: 500), () {
          try {
            if (savedPosition != null && savedPosition > Duration.zero) {
              debugPrint('▶️ MANAGER: Starting YouTube from ${savedPosition.inSeconds}s');
              controller.seekTo(savedPosition);
            }
            controller.play();
            debugPrint('▶️ MANAGER: Started YouTube after delay');
          } catch (e) {
            debugPrint('Error playing YouTube after delay: $e');
          }
        });
      } else {
        if (savedPosition != null && savedPosition > Duration.zero) {
          debugPrint('▶️ MANAGER: Starting YouTube from ${savedPosition.inSeconds}s');
          controller.seekTo(savedPosition);
        }
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
          debugPrint('🛑 MANAGER: Saved position ${currentPosition.inSeconds}s for $_currentPlayingId before pauseAll');
          
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
            debugPrint('🛑 MANAGER: Video paused at ${currentPosition.inSeconds}s');
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
      debugPrint('🧹 MANAGER CLEANUP: Removed ${keysToRemove.length} old positions');
    }
  }

  /// Dispose كل الـ controllers عند الخروج من Reels
  Future<void> disposeAll() async {
    debugPrint(
      '🚮 MANAGER DISPOSE ALL: Clearing ${_savedPositions.length} saved positions',
    );
    await _pauseAll();
    _currentVideoController = null;
    _currentYoutubeController = null;
    _currentPlayingId = null;
    _savedPositions.clear();
  }
}
