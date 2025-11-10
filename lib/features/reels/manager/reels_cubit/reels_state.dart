import 'package:sahifa/core/model/reels_model/reel.dart';

abstract class ReelsState {}

class ReelsInitial extends ReelsState {}

class ReelsLoading extends ReelsState {}

class ReelsLoaded extends ReelsState {
  final List<Reel> reels;
  final int currentIndex;
  final bool hasMore;
  final bool isLoadingMore;
  final String? error;

  ReelsLoaded({
    required this.reels,
    this.currentIndex = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.error,
  });

  ReelsLoaded copyWith({
    List<Reel>? reels,
    int? currentIndex,
    bool? hasMore,
    bool? isLoadingMore,
    String? error,
  }) {
    return ReelsLoaded(
      reels: reels ?? this.reels,
      currentIndex: currentIndex ?? this.currentIndex,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
    );
  }
}

class ReelsError extends ReelsState {
  final String message;

  ReelsError(this.message);
}
