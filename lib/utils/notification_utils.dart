import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../screens/widgets/text_widget.dart';

class NotificationUtils {
  static void showSuccess({
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      backgroundColor: const Color(0xFFE8F5E9),
      foregroundColor: const Color(0xFF1B5E20),
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      title: const TextWidget(
        'Success',
        size: 16,
        weight: FontWeight.w600,
        color: Color(0xFF1B5E20),
      ),
      description: TextWidget(
        message,
        size: 14,
        color: const Color(0xFF2E7D32),
      ),
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: Color(0xFF1B5E20),
      ),
    );
  }

  static void showError({
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      backgroundColor: const Color(0xFFFFEBEE),
      foregroundColor: const Color(0xFFB71C1C),
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      title: const TextWidget(
        'Error',
        size: 16,
        weight: FontWeight.w600,
        color: Color(0xFFB71C1C),
      ),
      description: TextWidget(
        message,
        size: 14,
        color: const Color(0xFFC62828),
      ),
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Color(0xFFB71C1C),
      ),
    );
  }

  static void showWarning({
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      backgroundColor: const Color(0xFFFFF3E0),
      foregroundColor: const Color(0xFFF57F17),
      autoCloseDuration: duration ?? const Duration(seconds: 3),
      title: const TextWidget(
        'Warning',
        size: 16,
        weight: FontWeight.w600,
        color: Color(0xFFF57F17),
      ),
      description: TextWidget(
        message,
        size: 14,
        color: const Color(0xFFF9A825),
      ),
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Color(0xFFF57F17),
      ),
    );
  }

  static void showInfo({
    required String message,
    Duration? duration,
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      backgroundColor: const Color(0xFFE3F2FD),
      foregroundColor: const Color(0xFF0277BD),
      autoCloseDuration: duration ?? const Duration(seconds: 2),
      title: const TextWidget(
        'Info',
        size: 16,
        weight: FontWeight.w600,
        color: Color(0xFF0277BD),
      ),
      description: TextWidget(
        message,
        size: 14,
        color: const Color(0xFF0288D1),
      ),
      icon: const Icon(
        Icons.info_outline_rounded,
        color: Color(0xFF0277BD),
      ),
    );
  }
}
