part of 'like_reel_cubit.dart';

@immutable
sealed class LikeReelState {}

final class LikeReelInitial extends LikeReelState {}

final class LikeReelLoading extends LikeReelState {
  final String reelId;
  final bool isLiking; // true = liking, false = unliking

  LikeReelLoading({required this.reelId, required this.isLiking});
}

final class LikeReelSuccess extends LikeReelState {
  final String reelId;
  final bool isLiked; // true = liked, false = unliked

  LikeReelSuccess({required this.reelId, required this.isLiked});
}

final class LikeReelError extends LikeReelState {
  final String reelId;
  final String message;
  final bool wasLiked; // Previous state to revert

  LikeReelError({
    required this.reelId,
    required this.message,
    required this.wasLiked,
  });
}
