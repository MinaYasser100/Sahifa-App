import 'package:flutter/material.dart';
import 'package:sahifa/core/model/comment_model/comment_model.dart';
import 'package:sahifa/core/widgets/custom_comment_item/comments_filter_helper.dart';
import 'package:sahifa/core/widgets/custom_comment_item/custom_comment_item.dart';

class CommentsList extends StatelessWidget {
  final List<CommentModel> comments;
  final String? currentUserId; // Current user ID

  const CommentsList({super.key, required this.comments, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    // Filter comments based on approval and current user
    final filteredComments = CommentsFilterHelper.filterComments(
      comments: comments,
      currentUserId: currentUserId,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredComments.length,
      itemBuilder: (context, index) {
        return CommentItem(
          comment: filteredComments[index],
          currentUserId: currentUserId,
        );
      },
    );
  }
}
