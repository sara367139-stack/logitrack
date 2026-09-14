import 'package:flutter/material.dart';

import 'package:logitrack/core/theme/app_theme.dart';

enum NotifKind { critical, warning, info, success }

extension NotifKindX on NotifKind {
  Color get color {
    switch (this) {
      case NotifKind.critical:
        return AppColors.red;
      case NotifKind.warning:
        return AppColors.orange;
      case NotifKind.info:
        return AppColors.primary;
      case NotifKind.success:
        return AppColors.green;
    }
  }
}

enum NotifGroup { today, yesterday, earlier }

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.kind,
    required this.group,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.tag,
    required this.locationTag,
    required this.icon,
    required this.actionLabel,
    this.unread = false,
    this.category = 'all',
  });

  final String id;
  final NotifKind kind;
  final NotifGroup group;
  final String title;
  final String body;
  final String timeLabel;
  final String tag;
  final String locationTag;
  final IconData icon;
  final String actionLabel;
  final bool unread;
  final String category; // alerts / orders / audit

  Color get color => kind.color;

  bool matchesCategory(String cat) {
    if (cat == 'all') return true;
    return category == cat;
  }
}