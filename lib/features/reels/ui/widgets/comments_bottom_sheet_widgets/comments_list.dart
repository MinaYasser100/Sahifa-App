import 'package:flutter/material.dart';
import 'package:sahifa/features/details_artical/data/models/comment_model.dart';
import 'package:sahifa/features/details_artical/ui/widgets/comment_item.dart';

class CommentsList extends StatelessWidget {
  final List<CommentModel> comments;

  const CommentsList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentItem(comment: comments[index]);
      },
    );
  }
}
