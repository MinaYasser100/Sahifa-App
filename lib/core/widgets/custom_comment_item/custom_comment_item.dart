import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/comment_model/comment_model.dart';

import 'custom_info_user.dart';
import 'pending_approval_widget.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    super.key,
    required this.comment,
    this.currentUserId, // Current user ID to check if comment is user's own
  });

  final CommentModel comment;
  final String? currentUserId;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool get _isPendingApproval {
    // Show as pending if not approved AND belongs to current user
    return !widget.comment.isApproved &&
        widget.comment.userId == widget.currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeInLeft(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isPendingApproval
              ? (isDarkMode
                    ? Colors.grey[800]?.withValues(alpha: 0.5)
                    : Colors.grey[300]?.withValues(alpha: 0.5))
              : (isDarkMode
                    ? ColorsTheme().primaryLight
                    : ColorsTheme().whiteColor),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isPendingApproval
                ? Colors.grey.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pending approval badge
            if (_isPendingApproval) const PendingApprovalWidget(),

            // User Info Row
            CustomInfoUser(
              isPendingApproval: _isPendingApproval,
              isDarkMode: isDarkMode,
              widget: widget,
            ),
            const SizedBox(height: 12),
            // Comment Text
            FadeInUp(
              child: Text(
                widget.comment.comment,
                style: TextStyle(
                  color: _isPendingApproval
                      ? Colors.grey[600]
                      : (isDarkMode
                            ? ColorsTheme().whiteColor.withValues(alpha: 0.9)
                            : ColorsTheme().blackColor.withValues(alpha: 0.8)),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
