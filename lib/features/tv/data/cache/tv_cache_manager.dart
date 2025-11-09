import 'dart:developer';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';

/// Manages caching for TV videos with ETag support
class TVCacheManager {
  // Cache storage
  final Map<int, List<VideoModel>> _cachedVideosByPage = {};
  final Map<int, String> _cachedETagsByPage = {};
  final Map<int, int> _cachedTotalPagesByPage = {};
  final Map<int, DateTime> _cacheTimestampsByPage = {};

  // Cache configuration
  final Duration cacheDuration;
  String? _cachedLanguage;

  TVCacheManager({this.cacheDuration = const Duration(minutes: 30)});

  // ============= Getters =============

  /// Check if memory cache is valid (within duration)
  bool hasValidMemoryCache(int pageNumber) {
    return _cachedVideosByPage.containsKey(pageNumber) &&
        _cacheTimestampsByPage.containsKey(pageNumber) &&
        DateTime.now().difference(_cacheTimestampsByPage[pageNumber]!) <
            cacheDuration;
  }

  /// Check if we have cached data for a page
  bool hasCachedData(int pageNumber) {
    return _cachedVideosByPage.containsKey(pageNumber);
  }

  /// Check if we have ETag for a page
  bool hasETag(int pageNumber) {
    return _cachedETagsByPage.containsKey(pageNumber);
  }

  /// Get cached videos for a page
  List<VideoModel>? getCachedVideos(int pageNumber) {
    return _cachedVideosByPage[pageNumber];
  }

  /// Get ETag for a page
  String? getETag(int pageNumber) {
    return _cachedETagsByPage[pageNumber];
  }

  /// Get total pages for a page
  int? getTotalPages(int pageNumber) {
    return _cachedTotalPagesByPage[pageNumber];
  }

  /// Get cached language
  String? get cachedLanguage => _cachedLanguage;

  // ============= Cache Operations =============

  /// Store videos, ETag, and metadata for a page
  void cachePageData({
    required int pageNumber,
    required List<VideoModel> videos,
    String? etag,
    int? totalPages,
  }) {
    _cachedVideosByPage[pageNumber] = videos;
    _cacheTimestampsByPage[pageNumber] = DateTime.now();

    if (etag != null) {
      _cachedETagsByPage[pageNumber] = etag;
      log('🏷️ Stored ETag for page $pageNumber: $etag');
    }

    if (totalPages != null) {
      _cachedTotalPagesByPage[pageNumber] = totalPages;
    }

    log('✅ Cached ${videos.length} videos for page $pageNumber');
  }

  /// Update only the timestamp (for 304 responses)
  void updateTimestamp(int pageNumber) {
    _cacheTimestampsByPage[pageNumber] = DateTime.now();
    log('⏱️ Updated timestamp for page $pageNumber');
  }

  /// Set cached language
  void setCachedLanguage(String language) {
    _cachedLanguage = language;
  }

  // ============= Cache Clearing =============

  /// Invalidate timestamps only (forces revalidation but keeps data)
  void invalidateTimestamps() {
    _cacheTimestampsByPage.clear();
    log(
      '⏱️ Cache timestamps invalidated (data & ETags preserved for revalidation)',
    );
  }

  /// Clear all cache including ETags
  void clearAll() {
    _cachedVideosByPage.clear();
    _cachedETagsByPage.clear();
    _cachedTotalPagesByPage.clear();
    _cacheTimestampsByPage.clear();
    _cachedLanguage = null;
    log('🗑️ All cache cleared (including ETags)');
  }

  /// Check if language has changed
  bool hasLanguageChanged(String newLanguage) {
    return _cachedLanguage != null && _cachedLanguage != newLanguage;
  }
}
