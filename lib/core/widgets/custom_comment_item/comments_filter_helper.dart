import 'package:sahifa/core/model/comment_model/comment_model.dart';

/// Helper class for filtering comments based on approval status
class CommentsFilterHelper {
  CommentsFilterHelper._();

  /// Filter comments based on approval status and current user
  ///
  /// Logic:
  /// - If isApproved = true → Show comment
  /// - If isApproved = false:
  ///   - If userId != currentUserId → Hide comment
  ///   - If userId == currentUserId → Show comment (will be displayed as pending)
  static List<CommentModel> filterComments({
    required List<CommentModel> comments,
    required String? currentUserId,
  }) {
    if (currentUserId == null || currentUserId.isEmpty) {
      // If no current user, only show approved comments
      return comments.where((comment) => comment.isApproved).toList();
    }

    return comments.where((comment) {
      // Show if approved
      if (comment.isApproved) return true;

      // Show if not approved BUT belongs to current user (will show as pending)
      if (comment.userId == currentUserId) return true;

      // Hide all other non-approved comments
      return false;
    }).toList();
  }

  /// Check if comment should be displayed as pending
  static bool isPendingApproval({
    required CommentModel comment,
    required String? currentUserId,
  }) {
    if (currentUserId == null || currentUserId.isEmpty) {
      return false;
    }

    return !comment.isApproved && comment.userId == currentUserId;
  }
}
