import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'custom_comment_item.dart';

class CustomInfoUser extends StatelessWidget {
  const CustomInfoUser({
    super.key,
    required bool isPendingApproval,
    required this.isDarkMode,
    required this.widget,
  }) : _isPendingApproval = isPendingApproval;

  final bool _isPendingApproval;
  final bool isDarkMode;
  final CommentItem widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // User Avatar
        FadeInLeft(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: _isPendingApproval
                ? Colors.grey.withValues(alpha: 0.3)
                : (isDarkMode
                      ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                      : ColorsTheme().primaryColor.withValues(alpha: 0.2)),
            child: Text(
              widget.comment.userName[0].toUpperCase(),
              style: TextStyle(
                color: _isPendingApproval
                    ? Colors.grey[600]
                    : ColorsTheme().primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // User Name and Time
        Expanded(
          child: FadeInRight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.comment.userName,
                    style: AppTextStyles.styleBold16sp(context).copyWith(
                      color: _isPendingApproval
                          ? Colors.grey[600]
                          : (isDarkMode
                                ? ColorsTheme().whiteColor
                                : ColorsTheme().blackColor),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeago.format(widget.comment.date, locale: 'en'),
                  style: AppTextStyles.styleMedium12sp(context).copyWith(
                    color: _isPendingApproval
                        ? Colors.grey[500]
                        : (isDarkMode
                              ? ColorsTheme().whiteColor.withValues(alpha: 0.8)
                              : ColorsTheme().grayColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
