class VideoUrlHelper {
  /// Check if URL is a YouTube video
  static bool isYouTubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube.com/shorts');
  }

  /// Extract YouTube video ID from URL
  static String? extractYouTubeId(String url) {
    // YouTube Shorts format: https://www.youtube.com/shorts/VIDEO_ID
    if (url.contains('/shorts/')) {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      final shortsIndex = segments.indexOf('shorts');
      if (shortsIndex != -1 && shortsIndex + 1 < segments.length) {
        return segments[shortsIndex + 1];
      }
    }

    // Regular YouTube format: https://www.youtube.com/watch?v=VIDEO_ID
    if (url.contains('youtube.com/watch')) {
      final uri = Uri.parse(url);
      return uri.queryParameters['v'];
    }

    // Short YouTube format: https://youtu.be/VIDEO_ID
    if (url.contains('youtu.be/')) {
      final uri = Uri.parse(url);
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    }

    return null;
  }

  /// Check if URL is a direct video file
  static bool isDirectVideoUrl(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v'];
    final lowerUrl = url.toLowerCase();
    return videoExtensions.any((ext) => lowerUrl.contains(ext));
  }

  /// Get video type
  static VideoType getVideoType(String url) {
    if (isYouTubeUrl(url)) {
      return VideoType.youtube;
    } else if (url.startsWith('assets/')) {
      return VideoType.asset;
    } else if (isDirectVideoUrl(url)) {
      return VideoType.network;
    }
    return VideoType.unknown;
  }
}

enum VideoType { youtube, network, asset, unknown }
