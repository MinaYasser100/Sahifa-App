import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key, required this.isDark});

  final bool isDark;

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
                Icons.person,
                color: ColorsTheme().whiteColor,
                size: 50,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
