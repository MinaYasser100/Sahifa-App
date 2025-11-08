import 'package:flutter/material.dart';
import 'package:sahifa/core/model/comment_model/comment_model.dart';
import 'package:sahifa/core/widgets/custom_comment_item/custom_comment_item.dart';

class ReelCommentsList extends StatelessWidget {
  final List<CommentModel> comments;
  final String? currentUserId; // Current user ID

  const ReelCommentsList({
    super.key,
    required this.comments,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CustomCommentItem(
          comment: comments[index],
          currentUserId: currentUserId,
        );
      },
    );
  }
}
