import 'package:flutter/material.dart';

import 'package:logitrack/core/services/storage_service.dart';

class AppSettings extends ChangeNotifier {
  AppSettings() {
    _locale = Locale(StorageService.languageCode);
    _themeMode =
        StorageService.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  late Locale _locale;
  late ThemeMode _themeMode;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  bool get isArabic => _locale.languageCode == 'ar';
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> setLocale(String code) async {
    if (_locale.languageCode == code) return;
    _locale = Locale(code);
    await StorageService.setLanguage(code);
    notifyListeners();
  }

  Future<void> toggleLocale() async => setLocale(isArabic ? 'en' : 'ar');

  Future<void> setDarkMode(bool v) async {
    _themeMode = v ? ThemeMode.dark : ThemeMode.light;
    await StorageService.setDarkMode(v);
    notifyListeners();
  }

  Future<void> toggleTheme() async => setDarkMode(!isDark);
}

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings super.notifier,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found');
    return scope!.notifier!;
  }
}