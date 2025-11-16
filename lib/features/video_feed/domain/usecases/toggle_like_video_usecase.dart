import 'package:fpdart/fpdart.dart';
import 'package:sahifa/features/video_feed/domain/repositories/video_feed_repository.dart';

class ToggleLikeVideoUseCase {
  const ToggleLikeVideoUseCase({required this.repository});

  final VideoFeedRepository repository;

  Future<Either<String, void>> call({
    required String videoId,
    required bool currentlyLiked,
  }) async {
    if (currentlyLiked) {
      return repository.unlikeVideo(videoId);
    } else {
      return repository.likeVideo(videoId);
    }
  }
}
