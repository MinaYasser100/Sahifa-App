part of 'audio_player_cubit.dart';

@immutable
sealed class AudioPlayerState {}

final class AudioPlayerInitial extends AudioPlayerState {}

final class AudioPlayerLoading extends AudioPlayerState {}

final class AudioPlayerPlaying extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  final double speed;

  AudioPlayerPlaying({
    required this.position,
    required this.duration,
    this.speed = 1.0,
  });
}

final class AudioPlayerPaused extends AudioPlayerState {
  final Duration position;
  final Duration duration;
  final double speed;

  AudioPlayerPaused({
    required this.position,
    required this.duration,
    this.speed = 1.0,
  });
}

final class AudioPlayerCompleted extends AudioPlayerState {}

final class AudioPlayerError extends AudioPlayerState {
  final String message;

  AudioPlayerError({required this.message});
}

final class AudioPlayerBuffering extends AudioPlayerState {
  final Duration position;
  final Duration duration;

  AudioPlayerBuffering({required this.position, required this.duration});
}
