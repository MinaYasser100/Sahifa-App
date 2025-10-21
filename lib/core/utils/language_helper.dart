import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/constant.dart';

/// Helper class to check app language
class LanguageHelper {
  /// Check if current language is Arabic
  static bool isArabic(BuildContext context) {
    return context.locale.languageCode == ConstantVariable.arabicLangCode;
  }

  /// Check if current language is English
  static bool isEnglish(BuildContext context) {
    return context.locale.languageCode == ConstantVariable.englishLangCode;
  }

  /// Get current language code
  static String getCurrentLanguageCode(BuildContext context) {
    return context.locale.languageCode;
  }

  /// Get current locale
  static Locale getCurrentLocale(BuildContext context) {
    return context.locale;
  }
}
