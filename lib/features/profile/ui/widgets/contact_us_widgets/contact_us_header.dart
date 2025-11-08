import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class ContactUsHeader extends StatelessWidget {
  const ContactUsHeader({
    super.key,
    required this.isDark,
    required this.colors,
  });

  final bool isDark;
  final ColorsTheme colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDark
                  ? colors.primaryColor.withValues(alpha: 0.2)
                  : colors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.contact_support,
              size: 50,
              color: isDark ? colors.secondaryColor : colors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'contact_us_title'.tr(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? colors.whiteColor : colors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'contact_description'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: isDark ? colors.softBlue : colors.grayColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
