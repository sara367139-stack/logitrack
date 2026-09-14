import 'package:flutter/material.dart';

import 'package:logitrack/core/services/storage_service.dart';

/// مدير اللغة — بدون مكتبات خارجية
class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _locale = Locale(StorageService.languageCode);
  }

  late Locale _locale;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> setLocale(String code) async {
    if (_locale.languageCode == code) return;
    _locale = Locale(code);
    await StorageService.setLanguage(code);
    notifyListeners();
  }

  Future<void> toggle() async {
    await setLocale(isArabic ? 'en' : 'ar');
  }
}

/// InheritedNotifier عشان نوصل للـ Provider من أي مكان
class LocaleScope extends InheritedNotifier<LocaleProvider> {
  const LocaleScope({
    super.key,
    required LocaleProvider super.notifier,
    required super.child,
  });

  static LocaleProvider of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found in widget tree');
    return scope!.notifier!;
  }
}