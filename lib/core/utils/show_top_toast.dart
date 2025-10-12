import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

void showSuccessToast(BuildContext context, String title, String message) {
  MotionToast.success(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    description: Text(message, style: const TextStyle(color: Colors.white)),
    animationType: AnimationType.slideInFromTop,
    toastDuration: const Duration(seconds: 3),
    toastAlignment: Alignment.topCenter,
    borderRadius: 12,
    width: 300,
    height: 80,
    barrierColor: Colors.transparent,
  ).show(context);
}

void showErrorToast(BuildContext context, String title, String message) {
  MotionToast.error(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    ),
    description: Text(message, style: const TextStyle(color: Colors.white)),
    animationType: AnimationType.slideInFromTop,
    toastDuration: const Duration(seconds: 3),
    toastAlignment: Alignment.topCenter,
    borderRadius: 12,
    width: 300,
    height: 80,
    barrierColor: Colors.transparent,
  ).show(context);
}
