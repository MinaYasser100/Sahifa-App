import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class AuthorInfoRow extends StatelessWidget {
  const AuthorInfoRow({
    super.key,
    required this.authorImage,
    required this.authorName,
    required this.isDarkMode,
  });

  final String? authorImage;
  final String? authorName;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(authorImage ?? ''),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              authorName ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode
                    ? ColorsTheme().secondaryLight
                    : ColorsTheme().secondaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
