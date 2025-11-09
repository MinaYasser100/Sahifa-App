import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class AuthorProfileHeader extends StatelessWidget {
  const AuthorProfileHeader({
    super.key,
    required this.authorImage,
    required this.authorName,
  });

  final String? authorImage;
  final String authorName;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().primaryDark,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        // Author Avatar
        CircleAvatar(
          radius: 60,
          backgroundImage: authorImage != null && authorImage!.isNotEmpty
              ? NetworkImage(authorImage!)
              : null,
          backgroundColor: ColorsTheme().primaryColor,
          child: authorImage == null || authorImage!.isEmpty
              ? Icon(Icons.person, size: 60, color: ColorsTheme().whiteColor)
              : null,
        ),
        const SizedBox(height: 16),
        // Author Name
        Text(
          authorName,
          style: AppTextStyles.styleBold24sp(context).copyWith(
            color: isDarkMode
                ? ColorsTheme().whiteColor
                : ColorsTheme().primaryDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        // Divider
        Divider(
          thickness: 1,
          color: isDarkMode
              ? ColorsTheme().grayColor.withValues(alpha: 0.3)
              : ColorsTheme().grayColor.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
