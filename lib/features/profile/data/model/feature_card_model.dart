import 'package:flutter/material.dart';

class FeatureCardModel {
  final String? title;
  final String description;
  final IconData icon;
  final bool isDark;

  FeatureCardModel({
    this.title,
    required this.description,
    required this.icon,
    required this.isDark,
  });
}
