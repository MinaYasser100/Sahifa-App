part of 'video_player_cubit.dart';

@immutable
sealed class VideoPlayerState {}

final class VideoPlayerInitial extends VideoPlayerState {}

final class VideoPlayerLoading extends VideoPlayerState {}

final class VideoPlayerReady extends VideoPlayerState {
  final bool isPlaying;
  final bool isManuallyPaused; // لو المستخدم عمل pause يدوي

  VideoPlayerReady({required this.isPlaying, this.isManuallyPaused = false});
}

final class VideoPlayerError extends VideoPlayerState {
  final String message;

  VideoPlayerError({required this.message});
}
