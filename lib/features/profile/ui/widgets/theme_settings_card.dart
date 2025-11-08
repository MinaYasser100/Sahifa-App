import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/theme_cubit/theme_cubit.dart';
import 'package:sahifa/core/utils/colors.dart';

class ThemeSettingsCard extends StatelessWidget {
  const ThemeSettingsCard({
    super.key,
    required this.isDark,
    required this.themeCubit,
  });

  final bool isDark;
  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: ListTile(
          tileColor: isDark
              ? ColorsTheme().primaryLight
              : ColorsTheme().whiteColor,
          contentPadding: const EdgeInsets.all(12),
          leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 28),
          title: Text(
            isDark ? "dark_mode".tr() : "light_mode".tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            isDark ? "switch_to_light_theme".tr() : "switch_to_dark_theme".tr(),
          ),
          trailing: Switch(
            activeColor: ColorsTheme().whiteColor,
            value: isDark,
            onChanged: (value) {
              themeCubit.toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}
