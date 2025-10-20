part of 'tv_cubit.dart';

@immutable
abstract class TvState {}

class TvInitial extends TvState {}

class TvLoading extends TvState {}

class TvLoaded extends TvState {
  final List<VideoItemModel> videos;

  TvLoaded(this.videos);
}

class TvError extends TvState {
  final String message;

  TvError(this.message);
}
