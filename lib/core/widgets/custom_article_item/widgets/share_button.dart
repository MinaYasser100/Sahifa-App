import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share functionality will be implemented'.tr()),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: FadeInDown(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: CircleAvatar(
            backgroundColor: isDarkMode
                ? ColorsTheme().whiteColor.withValues(alpha: 0.3)
                : ColorsTheme().grayColor.withValues(alpha: 0.3),
            radius: 15,
            child: Icon(
              FontAwesomeIcons.share,
              size: 14,
              color: isDarkMode
                  ? ColorsTheme().secondaryLight
                  : ColorsTheme().primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
