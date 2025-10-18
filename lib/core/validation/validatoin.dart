import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Validation {
  static String? emailValidation(value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_your_email'.tr();
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'please_enter_a_valid_email'.tr();
    }
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'password_is_required'.tr();
    }
    if (value.length < 6) {
      return 'password_must_be_at_least_6_characters'.tr();
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_your_full_name'.tr();
    }

    // Remove extra spaces and split by spaces
    final nameParts = value.trim().split(RegExp(r'\s+'));

    if (nameParts.length < 3) {
      return 'please_enter_first_middle_last'.tr();
    }

    // Check if each name part has at least 2 characters
    for (var part in nameParts) {
      if (part.length < 3) {
        return 'each_name_must_be_at_least_2_characters'.tr();
      }
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return 'please_confirm_your_password'.tr();
    }
    if (value != passwordController.text) {
      return 'passwords_do_not_match'.tr();
    }
    return null;
  }
}
