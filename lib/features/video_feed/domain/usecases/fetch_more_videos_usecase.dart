import 'package:fpdart/fpdart.dart';
import 'package:sahifa/features/video_feed/domain/entities/video_entity.dart';
import 'package:sahifa/features/video_feed/domain/repositories/video_feed_repository.dart';

class FetchMoreVideosUseCase {
  FetchMoreVideosUseCase({required VideoFeedRepository repository})
    : _repository = repository;

  final VideoFeedRepository _repository;

  Future<Either<String, List<VideoEntity>>> call() {
    return _repository.fetchMoreVideos();
  }
}
