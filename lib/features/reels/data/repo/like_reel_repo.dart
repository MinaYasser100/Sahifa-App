import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';

abstract class LikeReelRepo {
  /// Like a reel
  Future<void> likeReel(String reelId);

  /// Unlike a reel
  Future<void> unlikeReel(String reelId);
}

class LikeReelRepoImpl implements LikeReelRepo {
  // Singleton Pattern
  static final LikeReelRepoImpl _instance = LikeReelRepoImpl._internal(
    DioHelper(),
  );
  factory LikeReelRepoImpl() => _instance;

  LikeReelRepoImpl._internal(this._dioHelper);

  final DioHelper _dioHelper;

  @override
  Future<void> likeReel(String reelId) async {
    try {
      log('❤️ Liking reel: $reelId');

      final endpoint = ApiEndpoints.likeReel.withParams({'reelId': reelId});

      final response = await _dioHelper.postData(
        url: endpoint,
        data: {
          ApiQueryParams.reelId: reelId,
        }, // Empty body for like endpoint
      );

      // 204 No Content - Success
      if (response.statusCode == 204) {
        log('✅ Reel liked successfully');
        return;
      }

      log('⚠️ Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      log('❌ Error liking reel: ${e.response?.statusCode} - ${e.message}');

      // Handle specific error codes
      switch (e.response?.statusCode) {
        case 401:
          throw Exception('Unauthorized: Please login first');
        case 404:
          throw Exception('Reel not found');
        case 409:
          throw Exception('Already liked this reel');
        case 422:
          throw Exception('Invalid request');
        default:
          throw Exception('Failed to like reel: ${e.message}');
      }
    } catch (e) {
      log('❌ Unexpected error: $e');
      throw Exception('Failed to like reel: $e');
    }
  }

  @override
  Future<void> unlikeReel(String reelId) async {
    try {
      log('💔 Unliking reel: $reelId');

      final endpoint = ApiEndpoints.likeReel.withParams({'reelId': reelId});

      final response = await _dioHelper.deleteData(url: endpoint);

      // 204 No Content - Success
      if (response.statusCode == 204) {
        log('✅ Reel unliked successfully');
        return;
      }

      log('⚠️ Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      log('❌ Error unliking reel: ${e.response?.statusCode} - ${e.message}');

      // Handle specific error codes
      switch (e.response?.statusCode) {
        case 401:
          throw Exception('Unauthorized: Please login first');
        case 404:
          throw Exception('Reel not found');
        case 409:
          throw Exception('Like not found');
        case 422:
          throw Exception('Invalid request');
        default:
          throw Exception('Failed to unlike reel: ${e.message}');
      }
    } catch (e) {
      log('❌ Unexpected error: $e');
      throw Exception('Failed to unlike reel: $e');
    }
  }
}
