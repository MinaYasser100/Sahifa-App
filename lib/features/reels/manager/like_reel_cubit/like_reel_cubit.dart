import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sahifa/features/reels/data/repo/like_reel_repo.dart';

part 'like_reel_state.dart';

class LikeReelCubit extends Cubit<LikeReelState> {
  final LikeReelRepo _likeReelRepo;

  LikeReelCubit(this._likeReelRepo) : super(LikeReelInitial());

  /// Toggle like/unlike for a reel
  ///
  /// [reelId] - ID of the reel to like/unlike
  /// [currentlyLiked] - Current like state (true = liked, false = not liked)
  Future<void> toggleLike({
    required String reelId,
    required bool currentlyLiked,
  }) async {
    if (isClosed) return;

    try {
      log(
        '🔄 Toggling like for reel: $reelId (Currently liked: $currentlyLiked)',
      );

      // Emit loading state
      emit(LikeReelLoading(reelId: reelId, isLiking: !currentlyLiked));

      // Call API
      if (currentlyLiked) {
        // Unlike
        await _likeReelRepo.unlikeReel(reelId);
        log('💔 Unliked reel: $reelId');
      } else {
        // Like
        await _likeReelRepo.likeReel(reelId);
        log('❤️ Liked reel: $reelId');
      }

      // Emit success state
      if (!isClosed) {
        emit(LikeReelSuccess(reelId: reelId, isLiked: !currentlyLiked));
      }
    } catch (e) {
      log('❌ Error toggling like: $e');

      // Emit error state with previous state for reverting
      if (!isClosed) {
        emit(
          LikeReelError(
            reelId: reelId,
            message: e.toString(),
            wasLiked: currentlyLiked,
          ),
        );
      }
    }
  }

  /// Like a reel
  Future<void> likeReel(String reelId) async {
    await toggleLike(reelId: reelId, currentlyLiked: false);
  }

  /// Unlike a reel
  Future<void> unlikeReel(String reelId) async {
    await toggleLike(reelId: reelId, currentlyLiked: true);
  }

  /// Reset state to initial
  void resetState() {
    if (!isClosed) {
      emit(LikeReelInitial());
    }
  }
}
