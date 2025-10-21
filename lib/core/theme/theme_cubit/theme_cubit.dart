import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/caching/shared/shared_perf_helper.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  // Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final isDark = SharedPrefHelper.instance.getBool(_themeKey) ?? false;
    emit(isDark ? ThemeDark() : ThemeLight());
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final isDark = state is ThemeDark;
    await SharedPrefHelper.instance.saveBool(_themeKey, !isDark);
    emit(isDark ? ThemeLight() : ThemeDark());
  }

  // Set specific theme
  Future<void> setLightTheme() async {
    await SharedPrefHelper.instance.saveBool(_themeKey, false);
    emit(ThemeLight());
  }

  Future<void> setDarkTheme() async {
    await SharedPrefHelper.instance.saveBool(_themeKey, true);
    emit(ThemeDark());
  }

  // Check if current theme is dark
  bool get isDarkMode => state is ThemeDark;
}
