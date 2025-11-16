import 'package:sahifa/features/video_feed/domain/entities/video_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class VideoFeedRepository {
  /// Fetch the initial batch of video items.
  /// Returns Either<String, List<VideoEntity>> where:
  /// - Left: Error message
  /// - Right: List of videos
  Future<Either<String, List<VideoEntity>>> fetchVideos();

  /// Fetch additional videos for pagination.
  /// Returns Either<String, List<VideoEntity>> where:
  /// - Left: Error message
  /// - Right: List of videos
  Future<Either<String, List<VideoEntity>>> fetchMoreVideos();

  /// Like a video by its ID.
  /// Returns Either<String, void> where:
  /// - Left: Error message
  /// - Right: success (no data)
  Future<Either<String, void>> likeVideo(String videoId);

  /// Unlike a video by its ID.
  /// Returns Either<String, void> where:
  /// - Left: Error message
  /// - Right: success (no data)
  Future<Either<String, void>> unlikeVideo(String videoId);
}
