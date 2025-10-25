part of 'tv_cubit.dart';

@immutable
abstract class TvState {}

class TvInitial extends TvState {}

class TvLoading extends TvState {}

class TvLoadingMore extends TvState {
  final List<VideoModel> currentVideos;

  TvLoadingMore(this.currentVideos);
}

class TvLoaded extends TvState {
  final List<VideoModel> videos;

  TvLoaded(this.videos);
}

class TvError extends TvState {
  final String message;

  TvError(this.message);
}
