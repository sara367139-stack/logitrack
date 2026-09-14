import 'package:flutter/material.dart';

import 'package:logitrack/core/localization/app_strings.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('ar')];

  bool get isArabic => locale.languageCode == 'ar';

  /// الترجمة
  String t(String key) {
    final map = AppStrings.values[key];
    if (map == null) return key;
    return map[locale.languageCode] ?? map['en'] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// اختصار سهل: context.tr('key')
extension LocalizationX on BuildContext {
  String tr(String key) => AppLocalizations.of(this).t(key);
  bool get isAr => AppLocalizations.of(this).isArabic;
}