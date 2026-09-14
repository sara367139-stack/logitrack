import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

enum SnackType { success, error, warning, info }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    late final Color color;
    late final IconData icon;

    switch (type) {
      case SnackType.success:
        color = AppColors.green;
        icon = Icons.check_circle_rounded;
        break;
      case SnackType.error:
        color = AppColors.red;
        icon = Icons.error_rounded;
        break;
      case SnackType.warning:
        color = AppColors.orange;
        icon = Icons.warning_rounded;
        break;
      case SnackType.info:
        color = AppColors.primary;
        icon = Icons.info_rounded;
        break;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.text,
          elevation: 6,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          action: actionLabel == null
              ? null
              : SnackBarAction(
                  label: actionLabel,
                  textColor: color,
                  onPressed: onAction ?? () {},
                ),
        ),
      );
  }

  static void success(BuildContext c, String m, {String? action, VoidCallback? onAction}) =>
      show(c, message: m, type: SnackType.success, actionLabel: action, onAction: onAction);

  static void error(BuildContext c, String m) =>
      show(c, message: m, type: SnackType.error);

  static void warning(BuildContext c, String m) =>
      show(c, message: m, type: SnackType.warning);

  static void info(BuildContext c, String m) =>
      show(c, message: m, type: SnackType.info);
}