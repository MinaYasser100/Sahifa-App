part of 'like_post_cubit.dart';

@immutable
sealed class LikePostState {}

final class LikePostInitial extends LikePostState {}

final class LikePostLoading extends LikePostState {
  final String postId;
  LikePostLoading(this.postId);
}

final class LikePostSuccess extends LikePostState {
  final String postId;
  final bool isLiked; // true = liked, false = unliked
  LikePostSuccess(this.postId, this.isLiked);
}

final class LikePostError extends LikePostState {
  final String postId;
  final String message;
  LikePostError(this.postId, this.message);
}
