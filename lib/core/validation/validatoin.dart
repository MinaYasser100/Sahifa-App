import 'package:flutter/material.dart';

class Validation {
  static String? emailValidation(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }

    // Remove extra spaces and split by spaces
    final nameParts = value.trim().split(RegExp(r'\s+'));

    if (nameParts.length < 3) {
      return 'Please enter (First, Middle, Last)';
    }

    // Check if each name part has at least 2 characters
    for (var part in nameParts) {
      if (part.length < 3) {
        return 'Each name must be at least 2 characters';
      }
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
