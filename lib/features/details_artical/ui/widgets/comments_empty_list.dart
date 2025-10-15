import 'package:animate_do/animate_do.dart';
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
              'There are no comments yet',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to comment on this article',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
