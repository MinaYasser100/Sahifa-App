import 'dart:developer';

/// Generic cache manager that can cache any type of data with ETag support
class GenericCacheManager<T> {
  // Cache storage
  final Map<int, List<T>> _cachedDataByPage = {};
  final Map<int, String> _cachedETagsByPage = {};
  final Map<int, int> _cachedTotalPagesByPage = {};
  final Map<int, DateTime> _cacheTimestampsByPage = {};

  // Cache configuration
  final Duration cacheDuration;
  final String cacheIdentifier; // For logging purposes
  String? _cachedLanguage;

  GenericCacheManager({
    this.cacheDuration = const Duration(minutes: 30),
    required this.cacheIdentifier,
  });

  // ============= Getters =============

  /// Check if memory cache is valid (within duration)
  bool hasValidMemoryCache(int pageNumber) {
    return _cachedDataByPage.containsKey(pageNumber) &&
        _cacheTimestampsByPage.containsKey(pageNumber) &&
        DateTime.now().difference(_cacheTimestampsByPage[pageNumber]!) <
            cacheDuration;
  }

  /// Check if we have cached data for a page
  bool hasCachedData(int pageNumber) {
    return _cachedDataByPage.containsKey(pageNumber);
  }

  /// Check if we have ETag for a page
  bool hasETag(int pageNumber) {
    return _cachedETagsByPage.containsKey(pageNumber);
  }

  /// Get cached data for a page
  List<T>? getCachedData(int pageNumber) {
    return _cachedDataByPage[pageNumber];
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

  /// Store data, ETag, and metadata for a page
  void cachePageData({
    required int pageNumber,
    required List<T> data,
    String? etag,
    int? totalPages,
  }) {
    _cachedDataByPage[pageNumber] = data;
    _cacheTimestampsByPage[pageNumber] = DateTime.now();

    if (etag != null) {
      _cachedETagsByPage[pageNumber] = etag;
      log('🏷️ [$cacheIdentifier] Stored ETag for page $pageNumber: $etag');
    }

    if (totalPages != null) {
      _cachedTotalPagesByPage[pageNumber] = totalPages;
    }

    log(
      '✅ [$cacheIdentifier] Cached ${data.length} items for page $pageNumber',
    );
  }

  /// Update only the timestamp (for 304 responses)
  void updateTimestamp(int pageNumber) {
    _cacheTimestampsByPage[pageNumber] = DateTime.now();
    log('⏱️ [$cacheIdentifier] Updated timestamp for page $pageNumber');
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
      '⏱️ [$cacheIdentifier] Cache timestamps invalidated (data & ETags preserved)',
    );
  }

  /// Clear all cache including ETags
  void clearAll() {
    _cachedDataByPage.clear();
    _cachedETagsByPage.clear();
    _cachedTotalPagesByPage.clear();
    _cacheTimestampsByPage.clear();
    _cachedLanguage = null;
    log('🗑️ [$cacheIdentifier] All cache cleared (including ETags)');
  }

  /// Check if language has changed
  bool hasLanguageChanged(String newLanguage) {
    return _cachedLanguage != null && _cachedLanguage != newLanguage;
  }
}
