import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/like_post/repo/like_post_repo.dart';

part 'like_post_state.dart';

class LikePostCubit extends Cubit<LikePostState> {
  final LikePostRepo _repo;

  LikePostCubit(this._repo) : super(LikePostInitial());

  /// Toggle like status for a post
  Future<void> toggleLike(String postId, bool currentLikeStatus) async {
    // Emit loading state
    emit(LikePostLoading(postId));

    // Call appropriate repository method based on current status
    final result = currentLikeStatus
        ? await _repo.unlikePost(postId) // If currently liked, unlike it
        : await _repo.likePost(postId); // If currently unliked, like it

    // Handle result
    result.fold(
      (error) {
        if (!isClosed) {
          emit(LikePostError(postId, error));
        }
      },
      (_) {
        if (!isClosed) {
          // Toggle the like status
          emit(LikePostSuccess(postId, !currentLikeStatus));
        }
      },
    );
  }

  /// Reset to initial state
  void reset() {
    if (!isClosed) {
      emit(LikePostInitial());
    }
  }
}
