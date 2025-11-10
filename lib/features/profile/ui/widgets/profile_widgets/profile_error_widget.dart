import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class ProfileErrorWidget extends StatelessWidget {
  const ProfileErrorWidget({
    super.key,
    required this.isDark,
    required this.message,
  });

  final bool isDark;
  final String message;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isDark
                  ? ColorsTheme().primaryLight
                  : ColorsTheme().primaryColor,
              radius: 50,
              child: Icon(
                Icons.error_outline,
                color: ColorsTheme().whiteColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
