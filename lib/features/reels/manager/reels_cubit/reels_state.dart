import 'package:sahifa/core/model/reel_model/reel_model.dart';

abstract class ReelsState {}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<ReelModel> reels;
  final int currentIndex;

  ReelsLoaded({required this.reels, this.currentIndex = 0});

  ReelsLoaded copyWith({List<ReelModel>? reels, int? currentIndex}) {
    return ReelsLoaded(
      reels: reels ?? this.reels,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class ReelsError extends ReelsState {
  final String message;

  ReelsError(this.message);
}
