import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

ThemeData themeDataFunc() {
  return ThemeData(
    scaffoldBackgroundColor: ColorsTheme().whiteColor,
    primaryColor: ColorsTheme().primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsTheme().primaryDark,
      brightness: Brightness.light,
      onPrimary: ColorsTheme().whiteColor,
      secondary: ColorsTheme().secondaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsTheme().primaryDark,
      foregroundColor: ColorsTheme().whiteColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorsTheme().whiteColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorsTheme().primaryDark,
      foregroundColor: ColorsTheme().whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsTheme().primaryDark,
        foregroundColor: ColorsTheme().whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    useMaterial3: true,
  );
}
