import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentsEmptyList extends StatelessWidget {
  const CommentsEmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Center(
        child: Column(
          children: [
            Icon(
              FontAwesomeIcons.commentSlash,
              color: Colors.grey[400],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'there_are_no_comments_yet'.tr(),
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'be_the_first_to_comment_on_this_article'.tr(),
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
