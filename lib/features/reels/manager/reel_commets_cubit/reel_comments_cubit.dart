import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/details_artical/data/models/comment_model.dart';

part 'reel_comments_state.dart';

class ReelCommentsCubit extends Cubit<ReelCommentsState> {
  ReelCommentsCubit() : super(ReelCommentsInitial());

  List<CommentModel> _comments = [];

  // Load comments for a specific reel
  Future<void> loadComments(String reelId) async {
    emit(ReelCommentsLoading());

    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Sample data - will be replaced with API
      _comments = [
        CommentModel(
          id: '1',
          userName: 'Ahmed Mohamed',
          userAvatar: '',
          userId: 'user_1',
          comment: 'Amazing content! 🔥',
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CommentModel(
          id: '2',
          userName: 'Fatima Ali',
          userAvatar: '',
          userId: 'user_2',
          comment: 'Great work, keep it up 👏',
          date: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        CommentModel(
          id: '3',
          userName: 'Mohamed Hassan',
          userAvatar: '',
          userId: 'user_3',
          comment: 'Excellent video!',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        CommentModel(
          id: '4',
          userName: 'Sarah Ibrahim',
          userAvatar: '',
          userId: 'user_4',
          comment: 'Very informative ❤️',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      emit(ReelCommentsLoaded(comments: List.from(_comments)));
    } catch (e) {
      emit(ReelCommentsError(message: 'Failed to load comments: $e'));
    }
  }

  // Add a new comment
  Future<void> addComment(String reelId, String commentText) async {
    if (commentText.trim().isEmpty) return;

    try {
      // TODO: Replace with API call to post comment
      await Future.delayed(const Duration(milliseconds: 300));

      final newComment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: 'You', // TODO: Get from user profile
        userAvatar: '',
        userId: 'current_user',
        comment: commentText.trim(),
        date: DateTime.now(),
      );

      _comments.insert(0, newComment);
      emit(CommentAdded(comments: List.from(_comments)));
      emit(ReelCommentsLoaded(comments: List.from(_comments)));
    } catch (e) {
      emit(ReelCommentsError(message: 'Failed to add comment: $e'));
      // Re-emit loaded state to keep showing comments
      emit(ReelCommentsLoaded(comments: List.from(_comments)));
    }
  }

  // Refresh comments
  Future<void> refreshComments(String reelId) async {
    await loadComments(reelId);
  }
}
