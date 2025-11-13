import 'package:equatable/equatable.dart';

/// حالات الفيديو
abstract class VideoPlayerState extends Equatable {
  const VideoPlayerState();

  @override
  List<Object?> get props => [];
}

/// حالة البداية
class VideoPlayerInitial extends VideoPlayerState {}

/// حالة التحميل
class VideoPlayerLoading extends VideoPlayerState {}

/// حالة الجاهزية
class VideoPlayerReady extends VideoPlayerState {
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  const VideoPlayerReady({
    required this.isPlaying,
    required this.position,
    required this.duration,
  });

  @override
  List<Object?> get props => [isPlaying, position, duration];

  VideoPlayerReady copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return VideoPlayerReady(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

/// حالة الخطأ
class VideoPlayerError extends VideoPlayerState {
  final String message;

  const VideoPlayerError({required this.message});

  @override
  List<Object?> get props => [message];
}
