import 'package:flutter/material.dart';
import 'package:sahifa/core/model/additional_setting_model/additional_setting_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class AdditionalSettingsItem extends StatelessWidget {
  const AdditionalSettingsItem({super.key, required this.model});
  final AdditionalSettingModel model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: model.isDark
          ? ColorsTheme().primaryLight
          : ColorsTheme().whiteColor,
      leading: Icon(
        model.icon,
        color: model.isDark
            ? ColorsTheme().whiteColor
            : ColorsTheme().primaryColor,
        size: 28,
      ),
      title: Text(
        model.title,
        style: AppTextStyles.styleMedium16sp(context).copyWith(
          color: model.isDark
              ? ColorsTheme().whiteColor
              : ColorsTheme().primaryDark,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: model.isDark
            ? ColorsTheme().whiteColor.withValues(alpha: 0.7)
            : ColorsTheme().primaryColor.withValues(alpha: 0.7),
      ),
      onTap: model.onTap,
    );
  }
}
