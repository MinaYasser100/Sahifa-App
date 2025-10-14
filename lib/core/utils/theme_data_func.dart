import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

// Light Theme
ThemeData themeDataFunc() {
  return ThemeData(
    scaffoldBackgroundColor: ColorsTheme().whiteColor,
    primaryColor: ColorsTheme().primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsTheme().primaryColor,
      brightness: Brightness.light,
      onPrimary: ColorsTheme().whiteColor,
      secondary: ColorsTheme().secondaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsTheme().primaryColor,
      foregroundColor: ColorsTheme().whiteColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorsTheme().whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorsTheme().primaryColor,
      foregroundColor: ColorsTheme().whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsTheme().primaryColor,
        foregroundColor: ColorsTheme().whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),
    useMaterial3: true,
  );
}

// Dark Theme
ThemeData darkThemeDataFunc() {
  return ThemeData(
    scaffoldBackgroundColor: ColorsTheme().backgroundColor,
    primaryColor: ColorsTheme().primaryDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsTheme().primaryDark,
      brightness: Brightness.dark,
      onPrimary: ColorsTheme().whiteColor,
      secondary: ColorsTheme().secondaryColor,
      surface: ColorsTheme().cardColor,
      onSurface: ColorsTheme().whiteColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsTheme().primaryDark,
      foregroundColor: ColorsTheme().whiteColor,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: ColorsTheme().whiteColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorsTheme().primaryColor,
      foregroundColor: ColorsTheme().whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsTheme().primaryColor,
        foregroundColor: ColorsTheme().whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 48),
      ),
    ),
    cardTheme: CardThemeData(color: ColorsTheme().cardColor, elevation: 4),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
    ),
    useMaterial3: true,
  );
}
