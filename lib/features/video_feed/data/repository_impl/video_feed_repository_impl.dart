import 'dart:developer';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/video_feed/data/models/response/video_response_model.dart';
import 'package:sahifa/features/video_feed/domain/entities/video_entity.dart';
import 'package:sahifa/features/video_feed/domain/repositories/video_feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class VideoFeedRepositoryImpl implements VideoFeedRepository {
  final DioHelper _dioHelper;
  String? _nextCursor;

  VideoFeedRepositoryImpl({required DioHelper dioHelper})
    : _dioHelper = dioHelper;

  @override
  Future<Either<String, List<VideoEntity>>> fetchVideos() async {
    try {
      log('📡 Fetching videos from API...');

      // Reset cursor for fresh fetch
      _nextCursor = null;

      // Build query parameters
      final Map<String, dynamic> queryParams = {};

      final response = await _dioHelper.getData(
        url: ApiEndpoints.getReels.path,
        query: queryParams.isNotEmpty ? queryParams : null,
      );

      log('✅ API Response Status: ${response.statusCode}');

      // Check if response data is valid
      if (response.data == null || response.data is! Map<String, dynamic>) {
        log('⚠️ Invalid response data type: ${response.data.runtimeType}');
        return Left('Invalid response format from server');
      }

      final responseData = response.data as Map<String, dynamic>;

      // Parse videos list from 'reels' key
      final videosList = responseData['reels'] as List<dynamic>? ?? [];

      if (videosList.isEmpty) {
        log('⚠️ No videos found in response');
        return const Right([]);
      }

      // Convert to VideoResponseModel then to VideoEntity
      final videos = videosList
          .map((video) {
            try {
              final model = VideoResponseModel.fromJson(
                video as Map<String, dynamic>,
              );
              return model.toEntity();
            } catch (e) {
              log('⚠️ Error parsing video: $e');
              return null;
            }
          })
          .whereType<VideoEntity>()
          .toList();

      // Store next cursor for pagination
      _nextCursor = responseData['nextCursor'] as String?;

      log('📦 Fetched ${videos.length} videos');
      log('➡️ Next Cursor: ${_nextCursor ?? "null"}');

      return Right(videos);
    } catch (e) {
      log('❌ Error fetching videos: $e');
      return Left('Failed to fetch videos: $e');
    }
  }

  @override
  Future<Either<String, List<VideoEntity>>> fetchMoreVideos() async {
    try {
      log('📡 Fetching more videos from API...');

      if (_nextCursor == null || _nextCursor!.isEmpty) {
        log('⚠️ No more videos available (cursor is null)');
        return const Right([]);
      }

      // Build query parameters with cursor
      final Map<String, dynamic> queryParams = {
        ApiQueryParams.cursor: _nextCursor,
      };

      final response = await _dioHelper.getData(
        url: ApiEndpoints.getReels.path,
        query: queryParams,
      );

      log('✅ API Response Status: ${response.statusCode}');

      // Check if response data is valid
      if (response.data == null || response.data is! Map<String, dynamic>) {
        log('⚠️ Invalid response data type: ${response.data.runtimeType}');
        return Left('Invalid response format from server');
      }

      final responseData = response.data as Map<String, dynamic>;

      // Parse videos list from 'reels' key
      final videosList = responseData['reels'] as List<dynamic>? ?? [];

      if (videosList.isEmpty) {
        log('⚠️ No more videos found in response');
        return const Right([]);
      }

      // Convert to VideoResponseModel then to VideoEntity
      final videos = videosList
          .map((video) {
            try {
              final model = VideoResponseModel.fromJson(
                video as Map<String, dynamic>,
              );
              return model.toEntity();
            } catch (e) {
              log('⚠️ Error parsing video: $e');
              return null;
            }
          })
          .whereType<VideoEntity>()
          .toList();

      // Update cursor for next pagination
      _nextCursor = responseData['nextCursor'] as String?;

      log('📦 Fetched ${videos.length} more videos');
      log('➡️ Next Cursor: ${_nextCursor ?? "null"}');

      return Right(videos);
    } catch (e) {
      log('❌ Error fetching more videos: $e');
      return Left('Failed to fetch more videos: $e');
    }
  }
}
