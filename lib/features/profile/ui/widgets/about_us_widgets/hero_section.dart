import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class HeroSection extends StatelessWidget {
  final bool isDark;

  const HeroSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [colors.primaryDark, colors.primaryColor]
              : [colors.primaryColor, colors.primaryLight],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colors.whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),

          const SizedBox(height: 8),
          Text(
            'your_daily_news_source'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: colors.whiteColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
