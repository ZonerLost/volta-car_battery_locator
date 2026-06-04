import 'package:fire_fighter/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackType { success, error, info }

class AppSnackBar {
  const AppSnackBar._();

  static void show(
    String title,
    String message, {
    SnackPosition snackPosition = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
    AppSnackType? type,
  }) {
    final resolvedType = type ?? _typeFromTitle(title, message);
    final color = kPrimaryColor4;

    Get.snackbar(
      title,
      message,
      snackPosition: snackPosition,
      duration: duration,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      borderRadius: 14,
      backgroundColor: color,
      colorText: kWhite,
      borderColor: kWhite.withOpacity(0.22),
      borderWidth: 1,
      boxShadows: [
        BoxShadow(
          color: color.withOpacity(0.34),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
      icon: Icon(
        resolvedType == AppSnackType.success
            ? Icons.check_circle_rounded
            : resolvedType == AppSnackType.error
            ? Icons.error_rounded
            : Icons.info_rounded,
        color: kWhite,
      ),
      shouldIconPulse: false,
      barBlur: 0,
      overlayBlur: 0,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }

  static AppSnackType _typeFromTitle(String title, String message) {
    final lower = title.toLowerCase();
    if (lower.contains("success") ||
        lower.contains("submitted") ||
        lower.contains("sent")) {
      return AppSnackType.success;
    }
    final lowerMessage = message.toLowerCase();
    if (lower.contains("error") ||
        lower.contains("failed") ||
        lower.contains("required") ||
        lower.contains("validation") ||
        lowerMessage.contains("error") ||
        lowerMessage.contains("failed") ||
        lowerMessage.contains("invalid") ||
        lowerMessage.contains("please enter")) {
      return AppSnackType.error;
    }
    return AppSnackType.info;
  }
}
