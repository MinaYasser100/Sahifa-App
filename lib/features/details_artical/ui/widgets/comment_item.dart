import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/details_artical/data/models/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment});

  final CommentModel comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryLight
            : ColorsTheme().whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                    : ColorsTheme().primaryColor.withValues(alpha: 0.2),
                child: Text(
                  widget.comment.userName[0].toUpperCase(),
                  style: TextStyle(
                    color: ColorsTheme().primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Name and Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.comment.userName,
                        style: AppTextStyles.styleBold16sp(context).copyWith(
                          color: isDarkMode
                              ? ColorsTheme().whiteColor
                              : ColorsTheme().blackColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeago.format(widget.comment.date, locale: 'en'),
                      style: AppTextStyles.styleMedium12sp(context).copyWith(
                        color: isDarkMode
                            ? ColorsTheme().whiteColor.withValues(alpha: 0.8)
                            : ColorsTheme().grayColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment Text
          Text(
            widget.comment.comment,
            style: TextStyle(
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.9)
                  : ColorsTheme().blackColor.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
