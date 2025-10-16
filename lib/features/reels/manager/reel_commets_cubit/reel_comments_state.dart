part of 'reel_comments_cubit.dart';

@immutable
sealed class ReelCommentsState {}

final class ReelCommentsInitial extends ReelCommentsState {}

final class ReelCommentsLoading extends ReelCommentsState {}

final class ReelCommentsLoaded extends ReelCommentsState {
  final List<CommentModel> comments;

  ReelCommentsLoaded({required this.comments});
}

final class ReelCommentsError extends ReelCommentsState {
  final String message;

  ReelCommentsError({required this.message});
}

final class CommentAdded extends ReelCommentsState {
  final List<CommentModel> comments;

  CommentAdded({required this.comments});
}
