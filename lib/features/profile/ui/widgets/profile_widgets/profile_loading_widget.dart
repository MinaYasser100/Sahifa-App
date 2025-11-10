import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key, required this.isDark});

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
              child: CircularProgressIndicator(color: ColorsTheme().whiteColor),
            ),
            const SizedBox(height: 16),
            Text('loading'.tr(), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
