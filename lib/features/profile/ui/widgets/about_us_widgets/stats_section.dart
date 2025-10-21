import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

import 'stat_item.dart';

class StatsSection extends StatelessWidget {
  final bool isDark;

  const StatsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? colors.primaryColor.withValues(alpha: 0.2)
            : colors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            value: '60+',
            label: 'years_experience'.tr(),
            isDark: isDark,
          ),
          Container(
            height: 50,
            width: 1,
            color: isDark
                ? colors.softBlue.withValues(alpha: 0.3)
                : colors.grayColor.withValues(alpha: 0.3),
          ),
          StatItem(value: '1M+', label: 'daily_readers'.tr(), isDark: isDark),
          Container(
            height: 50,
            width: 1,
            color: isDark
                ? colors.softBlue.withValues(alpha: 0.3)
                : colors.grayColor.withValues(alpha: 0.3),
          ),
          StatItem(value: '24/7', label: 'news_updates'.tr(), isDark: isDark),
        ],
      ),
    );
  }
}
