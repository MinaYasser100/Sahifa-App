import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/decoration_circles_widget.dart';

class CustomAudioMagazineSection extends StatelessWidget {
  const CustomAudioMagazineSection({super.key, this.notMargin = false});
  final bool notMargin;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push(Routes.audioMagazineView);
      },
      child: Container(
        width: double.infinity,
        height: 80,
        margin: EdgeInsets.symmetric(
          horizontal: notMargin ? 0 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isDarkMode
              ? ColorsTheme().primaryLight
              : ColorsTheme().primaryColor,
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
            DecorationCirclesWidget(isDarkMode: isDarkMode),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.headphones,
                    color: ColorsTheme().whiteColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'audio_magazine'.tr(),
                    style: TextStyle(
                      color: ColorsTheme().whiteColor,
                      fontSize: 20,
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
