import 'package:flutter/material.dart';

class ColorsTheme {
  // Private constructor to prevent external instantiation
  ColorsTheme._();

  // Static instance of the class
  static final ColorsTheme _instance = ColorsTheme._();

  // Factory constructor to return the same instance
  factory ColorsTheme() => _instance;

  // Primary color (Dark Navy)
  final primaryDark = const Color(0xFF021024); // Darkest Blue
  final primaryColor = const Color(0xFF052659); // Deep Blue
  final primaryLight = const Color(0xFF345B83); // Medium Blue

  // Secondary colors (lighter shades)
  final secondaryColor = const Color(0xFF7DA0CA); // Light Blue
  final secondaryLight = const Color(0xFFC1E8FF); // Very Light Blue

  // Neutral / Background colors
  final whiteColor = Colors.white;
  final backgroundColor = const Color(
    0xFF021024,
  ); // Same as primary for dark mode
  final cardColor = const Color(0xFF052659); // Card background darker tone
  final softBlue = const Color(0xFF7DA0CA); // Soft grayish blue
  final grayColor = const Color.fromARGB(255, 178, 178, 178); // Light gray

  // Accent (اختياري: ناخد أفتح درجة للهايلايت)
  final accentColor = const Color(0xFFC1E8FF); // Accent highlight

  // Error color
  final errorColor = const Color(0xFFD32F2F); // Red for errors
  final successColor = const Color(0xFF388E3C); // Green for success
  final blackColor = Colors.black;
  final dividerColor = const Color(0xFFE0E0E0); // Light gray for dividers
  final errorIconColor = const Color.fromARGB(
    255,
    211,
    47,
    47,
  ); // Dark Red for error icons
}
