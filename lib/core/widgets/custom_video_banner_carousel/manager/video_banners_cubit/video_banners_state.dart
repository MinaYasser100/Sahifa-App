part of 'video_banners_cubit.dart';

sealed class VideoBannersState {}

final class VideoBannersInitial extends VideoBannersState {}

final class VideoBannersLoading extends VideoBannersState {}

final class VideoBannersLoaded extends VideoBannersState {
  final List<VideoModel> videoBanners;
  VideoBannersLoaded(this.videoBanners);
}

final class VideoBannersError extends VideoBannersState {
  final String message;
  VideoBannersError(this.message);
}
