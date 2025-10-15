import 'package:flutter/widgets.dart';

class AdditionalSettingModel {
  final IconData icon;
  final String title;
  final void Function()? onTap;
  final bool isDark;

  const AdditionalSettingModel({
    required this.icon,
    required this.title,
    this.onTap,
    this.isDark = false,
  });
}
