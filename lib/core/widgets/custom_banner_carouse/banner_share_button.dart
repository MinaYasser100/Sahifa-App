import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';

class BannerShareButton extends StatelessWidget {
  const BannerShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle share action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('share_functionality_will_be_implemented'.tr()),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          FontAwesomeIcons.share,
          size: 16,
          color: ColorsTheme().primaryLight,
        ),
      ),
    );
  }
}
