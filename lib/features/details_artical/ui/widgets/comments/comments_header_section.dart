import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/comment_model/comment_model.dart';

class CommentsHeaderSection extends StatelessWidget {
  const CommentsHeaderSection({
    super.key,
    required this.isDarkMode,
    required this.comments,
  });

  final bool isDarkMode;
  final List<CommentModel> comments;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FontAwesomeIcons.comments,
            color: isDarkMode
                ? ColorsTheme().whiteColor
                : ColorsTheme().primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            "Comments".tr(),
            style: TextStyle(
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().blackColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                  : ColorsTheme().primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${comments.length}',
              style: TextStyle(
                color: isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
