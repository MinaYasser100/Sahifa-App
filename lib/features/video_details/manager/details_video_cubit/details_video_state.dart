part of 'details_video_cubit.dart';

@immutable
sealed class DetailsVideoState {}

final class DetailsVideoInitial extends DetailsVideoState {}

final class DetailsVideoLoading extends DetailsVideoState {}

final class DetailsVideoLoaded extends DetailsVideoState {
  final VideoModel video;
  DetailsVideoLoaded(this.video);
}

final class DetailsVideoError extends DetailsVideoState {
  final String message;
  DetailsVideoError(this.message);
}
