import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/details_artical/data/models/comment_model.dart';
import 'package:sahifa/features/details_artical/ui/widgets/add_comment_widget.dart';
import 'package:sahifa/features/details_artical/ui/widgets/comment_item.dart';

import 'comments_empty_list.dart';
import 'comments_header_section.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  // Sample comments data - في المستقبل هتيجي من الـ backend
  List<CommentModel> comments = [
    CommentModel(
      id: '1',
      userName: 'Mohamed Ahmed',
      userAvatar: '',
      comment:
          "This is a great article, very informative and well-written. Thanks for sharing!",
      date: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 12,
    ),
    CommentModel(
      id: '2',
      userName: 'Fatima Ali',
      userAvatar: '',
      comment: 'Valuable information, I hope for more of these topics',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 8,
    ),
    CommentModel(
      id: '3',
      userName: 'Mohamed Hassan',
      userAvatar: '',
      comment: 'Great article, keep up the good work!',
      date: DateTime.now().subtract(const Duration(days: 1)),
      likes: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          CommentsHeaderSection(isDarkMode: isDarkMode, comments: comments),
          const SizedBox(height: 20),

          // Add Comment Widget
          FadeInUp(child: AddCommentWidget()),
          const SizedBox(height: 24),

          // Comments List
          if (comments.isEmpty)
            CommentsEmptyList()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  child: CommentItem(comment: comments[index]),
                );
              },
            ),
        ],
      ),
    );
  }
}
