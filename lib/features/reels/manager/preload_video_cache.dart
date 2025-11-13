import 'package:video_player/video_player.dart';

class PreloadVideoCache {
  PreloadVideoCache._private();

  static final PreloadVideoCache instance = PreloadVideoCache._private();

  final Map<String, VideoPlayerController> _cache = {};

  /// Preload a network video URL into memory and initialize its controller.
  /// If already preloaded, returns immediately.
  Future<void> preload(String url) async {
    if (url.isEmpty) return;

    final existing = _cache[url];
    if (existing != null) {
      // already preloaded
      return;
    }

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      controller.setLooping(true);
      _cache[url] = controller;
    } catch (e) {
      // preload failed — ensure no leftover controller
      try {
        _cache[url]?.dispose();
      } catch (_) {}
      _cache.remove(url);
    }
  }

  /// Get a preloaded controller if exists (may be null)
  VideoPlayerController? get(String url) => _cache[url];

  /// Dispose and remove a preloaded controller
  Future<void> disposeUrl(String url) async {
    final c = _cache.remove(url);
    try {
      await c?.dispose();
    } catch (_) {}
  }

  /// Clear all cached controllers
  Future<void> clear() async {
    for (final c in _cache.values) {
      try {
        await c.dispose();
      } catch (_) {}
    }
    _cache.clear();
  }
}
