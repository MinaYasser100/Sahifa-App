import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';
import 'package:sahifa/features/reels/data/reels_repo.dart';

class ReelsCubit extends Cubit<ReelsState> {
  final ReelsRepo reelsRepo;

  ReelsCubit(this.reelsRepo) : super(ReelsInitial());

  Future<void> loadReels() async {
    if (isClosed) return;
    
    try {
      emit(ReelsLoading());

      // Load reels from repo
      final reels = ReelsRepo.getLocalReels();

      // For backend:
      // final reels = await reelsRepo.fetchReelsFromBackend();

      if (isClosed) return;
      emit(ReelsLoaded(reels: reels));
    } catch (e) {
      if (!isClosed) emit(ReelsError('Error loading reels: $e'));
    }
  }

  void changePage(int index) {
    if (isClosed) return;
    
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      emit(currentState.copyWith(currentIndex: index));
    }
  }

  void toggleLike(String reelId) {
    if (isClosed) return;
    
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == reelId) {
          final newIsLiked = !reel.isLiked;
          final newLikes = newIsLiked ? reel.likes + 1 : reel.likes - 1;
          return reel.copyWith(isLiked: newIsLiked, likes: newLikes);
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));

      // await reelsRepo.likeReel(reelId);
    }
  }

  Future<void> refreshReels() async {
    await loadReels();
  }
}
