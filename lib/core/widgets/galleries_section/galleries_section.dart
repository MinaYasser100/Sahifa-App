import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/decoration_circles_widget.dart';

class GalleriesSection extends StatelessWidget {
  const GalleriesSection({
    super.key,
    this.notMargin = false,
    this.isDecorated = false,
    this.onTap,
  });
  final bool notMargin;
  final bool isDecorated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        margin: EdgeInsets.symmetric(
          horizontal: notMargin ? 0 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    ColorsTheme().primaryLight,
                    ColorsTheme().primaryLight.withValues(alpha: 0.8),
                  ]
                : isDecorated
                ? [
                    ColorsTheme().primaryColor.withValues(alpha: 0.9),
                    ColorsTheme().primaryColor.withValues(alpha: 0.7),
                  ]
                : [
                    ColorsTheme().primaryColor,
                    ColorsTheme().primaryColor.withValues(alpha: 0.8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (isDecorated) DecorationCirclesWidget(isDarkMode: isDarkMode),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.images,
                    color: ColorsTheme().whiteColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'galleries'.tr(),
                    style: TextStyle(
                      color: ColorsTheme().whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
