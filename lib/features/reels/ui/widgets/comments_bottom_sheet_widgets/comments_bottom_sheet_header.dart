import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CommentsBottomSheetHeader extends StatelessWidget {
  final int commentsCount;
  final bool isDarkMode;

  const CommentsBottomSheetHeader({
    super.key,
    required this.commentsCount,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.comment_outlined,
            color: isDarkMode
                ? ColorsTheme().whiteColor
                : ColorsTheme().primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            'Comments ($commentsCount)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().primaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
