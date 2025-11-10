import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/reels_model/reels_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReelsApiRepo {
  final DioHelper _dioHelper;
  static const String _etagKey = 'reels_etag';
  static const String _cachedReelsKey = 'cached_reels';

  ReelsApiRepo(this._dioHelper);

  /// Fetch reels from API with ETag caching support
  ///
  /// [cursor] - Cursor for pagination (null for first page)
  /// [limit] - Number of reels to fetch (default 20)
  Future<ReelsModel> fetchReels({String? cursor, int limit = 20}) async {
    try {
      log('📡 Fetching reels from API...');
      log('🔗 Cursor: ${cursor ?? "null (first page)"}');
      log('📊 Limit: $limit');

      // Get stored ETag
      final prefs = await SharedPreferences.getInstance();
      final storedETag = prefs.getString(_etagKey);

      // Build query parameters
      final Map<String, dynamic> queryParams = {ApiQueryParams.limit: limit};

      if (cursor != null && cursor.isNotEmpty) {
        queryParams[ApiQueryParams.cursor] = cursor;
      }

      // Set headers with ETag
      final Map<String, dynamic> headers = {};
      if (storedETag != null && cursor == null) {
        // Only use ETag for first page
        headers['If-None-Match'] = storedETag;
        log('🏷️ Using cached ETag: $storedETag');
      }

      try {
        final response = await _dioHelper.getData(
          url: ApiEndpoints.getReels.path,
          query: queryParams,
          headers: headers.isNotEmpty ? headers : null,
        );

        log('✅ API Response Status: ${response.statusCode}');

        // Check if response has new ETag
        final newETag = response.headers.value('etag');
        if (newETag != null && cursor == null) {
          await prefs.setString(_etagKey, newETag);
          log('💾 Stored new ETag: $newETag');
        }

        // Parse response
        final reelsModel = ReelsModel.fromJson(response.data);
        log('📦 Fetched ${reelsModel.reels.length} reels');
        log('➡️ Next Cursor: ${reelsModel.nextCursor ?? "null"}');
        log('🔄 Has More: ${reelsModel.hasMore}');

        // Cache first page data
        if (cursor == null) {
          await _cacheReelsData(response.data);
        }

        return reelsModel;
      } on DioException catch (e) {
        // Handle 304 Not Modified (cache hit)
        if (e.response?.statusCode == 304) {
          log('💾 Data not modified, using cached data');
          return await _getCachedReels();
        }
        rethrow;
      }
    } catch (e) {
      log('❌ Error fetching reels: $e');

      // Try to return cached data on error
      if (cursor == null) {
        try {
          log('🔄 Attempting to use cached data...');
          return await _getCachedReels();
        } catch (cacheError) {
          log('❌ No cached data available: $cacheError');
        }
      }

      rethrow;
    }
  }

  /// Cache reels data
  Future<void> _cacheReelsData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = data.toString();
      await prefs.setString(_cachedReelsKey, jsonString);
      log('💾 Cached reels data');
    } catch (e) {
      log('⚠️ Failed to cache reels data: $e');
    }
  }

  /// Get cached reels
  Future<ReelsModel> _getCachedReels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cachedReelsKey);

      if (cachedData == null) {
        throw Exception('No cached data available');
      }

      // Note: This is a simplified cache retrieval
      // In production, you'd want to properly serialize/deserialize JSON
      log('⚠️ Cache retrieval needs proper JSON handling');
      throw Exception('Cache retrieval not fully implemented');
    } catch (e) {
      log('❌ Error getting cached reels: $e');
      rethrow;
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_etagKey);
      await prefs.remove(_cachedReelsKey);
      log('🗑️ Cleared reels cache');
    } catch (e) {
      log('⚠️ Failed to clear cache: $e');
    }
  }

  /// Like/Unlike a reel
  Future<void> toggleReelLike(String reelId) async {
    try {
      log('❤️ Toggling like for reel: $reelId');

      // TODO: Replace with actual API endpoint when available
      // await _dioHelper.postData(
      //   url: '/api/v1/reels/$reelId/like',
      // );

      log('✅ Like toggled successfully');
    } catch (e) {
      log('❌ Error toggling like: $e');
      rethrow;
    }
  }

  /// Share a reel
  Future<void> shareReel(String reelId) async {
    try {
      log('📤 Sharing reel: $reelId');

      // TODO: Implement share logic

      log('✅ Reel shared successfully');
    } catch (e) {
      log('❌ Error sharing reel: $e');
      rethrow;
    }
  }
}
