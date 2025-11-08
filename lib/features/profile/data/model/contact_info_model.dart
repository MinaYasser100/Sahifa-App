import 'package:flutter/material.dart';

class ContactInfoModel {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;
  final VoidCallback? onTap;
  final VoidCallback onCopy;

  ContactInfoModel({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
    this.onTap,
    required this.onCopy,
  });
}
