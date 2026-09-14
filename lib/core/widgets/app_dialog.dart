import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

class AppDialog {
  AppDialog._();

  // ==================== CONFIRM ====================

  /// حوار تأكيد (نعم / لا)
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    IconData icon = Icons.help_outline_rounded,
    Color? color,
    bool danger = false,
  }) async {
    final c = danger ? AppColors.red : (color ?? AppColors.primary);

    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: c.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: c),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          side: BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: Text(
                          cancelLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: Text(
                          confirmLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }

  // ==================== SUCCESS ====================

  /// حوار نجاح (زرار واحد)
  static Future<void> success(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'Done',
    VoidCallback? onDone,
  }) {
    return _singleAction(
      context,
      title: title,
      message: message,
      buttonLabel: buttonLabel,
      icon: Icons.check_circle_rounded,
      color: AppColors.green,
      onDone: onDone,
    );
  }

  /// حوار خطأ
  static Future<void> error(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'Close',
    VoidCallback? onDone,
  }) {
    return _singleAction(
      context,
      title: title,
      message: message,
      buttonLabel: buttonLabel,
      icon: Icons.error_rounded,
      color: AppColors.red,
      onDone: onDone,
    );
  }

  /// حوار تحذير
  static Future<void> warning(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'Got it',
    VoidCallback? onDone,
  }) {
    return _singleAction(
      context,
      title: title,
      message: message,
      buttonLabel: buttonLabel,
      icon: Icons.warning_rounded,
      color: AppColors.orange,
      onDone: onDone,
    );
  }

  /// حوار معلومات
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'OK',
    VoidCallback? onDone,
  }) {
    return _singleAction(
      context,
      title: title,
      message: message,
      buttonLabel: buttonLabel,
      icon: Icons.info_rounded,
      color: AppColors.primary,
      onDone: onDone,
    );
  }

  static Future<void> _singleAction(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonLabel,
    required IconData icon,
    required Color color,
    VoidCallback? onDone,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 34, color: color),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDone?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== LOADING ====================

  static bool _loadingOpen = false;

  /// إظهار شاشة تحميل
  static void showLoading(BuildContext context, [String? message]) {
    if (_loadingOpen) return;
    _loadingOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 36,
                  width: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  message ?? 'Processing...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => _loadingOpen = false);
  }

  /// إخفاء شاشة التحميل
  static void hideLoading(BuildContext context) {
    if (!_loadingOpen) return;
    _loadingOpen = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  // ==================== BOTTOM SHEET ====================

  /// قائمة اختيار سريعة
  static Future<T?> picker<T>(
    BuildContext context, {
    required String title,
    required List<PickerOption<T>> options,
    T? selected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((o) {
              final isSel = o.value == selected;
              return ListTile(
                dense: true,
                leading: o.icon != null
                    ? Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primaryLight
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(
                          o.icon,
                          size: 17,
                          color: isSel
                              ? AppColors.primary
                              : AppColors.secondaryText,
                        ),
                      )
                    : Icon(
                        isSel
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 19,
                        color:
                            isSel ? AppColors.primary : AppColors.border,
                      ),
                title: Text(
                  o.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight:
                        isSel ? FontWeight.w900 : FontWeight.w700,
                    color: isSel ? AppColors.primary : AppColors.text,
                  ),
                ),
                subtitle: o.subtitle == null
                    ? null
                    : Text(
                        o.subtitle!,
                        style: TextStyle(
                          fontSize: 9.5,
                          color: AppColors.secondaryText,
                        ),
                      ),
                trailing: isSel && o.icon != null
                    ? Icon(Icons.check_circle_rounded,
                        size: 19, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, o.value),
              );
            }),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// خيار للـ picker
class PickerOption<T> {
  const PickerOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });

  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
}