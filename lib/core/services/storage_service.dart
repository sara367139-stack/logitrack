import 'package:shared_preferences/shared_preferences.dart';

import 'package:logitrack/core/constants/app_constants.dart';

class StorageService {
  StorageService._();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===== Onboarding =====
  static bool get onboardingSeen =>
      _prefs.getBool(StorageKeys.onboardingSeen) ?? false;

  static Future<void> setOnboardingSeen() =>
      _prefs.setBool(StorageKeys.onboardingSeen, true);

  // ===== Auth =====
  static bool get isLoggedIn =>
      _prefs.getBool(StorageKeys.isLoggedIn) ?? false;

  static Future<void> login({
    required String name,
    required String badge,
    bool remember = true,
  }) async {
    await _prefs.setBool(StorageKeys.isLoggedIn, true);
    await _prefs.setString(StorageKeys.userName, name);
    await _prefs.setString(StorageKeys.userBadge, badge);
    await _prefs.setBool(StorageKeys.rememberMe, remember);
  }

  static Future<void> logout() async {
    await _prefs.setBool(StorageKeys.isLoggedIn, false);
    if (!rememberMe) {
      await _prefs.remove(StorageKeys.userBadge);
    }
  }

  static String get userName =>
      _prefs.getString(StorageKeys.userName) ?? 'Sarah Jenkins';

  static String get userBadge =>
      _prefs.getString(StorageKeys.userBadge) ?? 'WH-OP-8924';

  static bool get rememberMe =>
      _prefs.getBool(StorageKeys.rememberMe) ?? true;

  // ===== Language =====
  static String get languageCode =>
      _prefs.getString(StorageKeys.languageCode) ?? 'en';

  static Future<void> setLanguage(String code) =>
      _prefs.setString(StorageKeys.languageCode, code);

  static bool get isArabic => languageCode == 'ar';

  // ===== Theme =====
  static bool get isDarkMode =>
      _prefs.getBool(StorageKeys.darkMode) ?? false;

  static Future<void> setDarkMode(bool v) =>
      _prefs.setBool(StorageKeys.darkMode, v);

  // ===== Warehouse =====
  static String get warehouse =>
      _prefs.getString(StorageKeys.warehouse) ??
      AppConstants.defaultWarehouse;

  static Future<void> setWarehouse(String w) =>
      _prefs.setString(StorageKeys.warehouse, w);

  // ===== Recent Searches =====
  static List<String> get recentSearches =>
      _prefs.getStringList(StorageKeys.recentSearches) ?? [];

  static Future<void> addRecentSearch(String q) async {
    if (q.trim().isEmpty) return;
    final list = recentSearches..remove(q);
    list.insert(0, q);
    if (list.length > 6) list.removeLast();
    await _prefs.setStringList(StorageKeys.recentSearches, list);
  }

  static Future<void> clearRecentSearches() =>
      _prefs.remove(StorageKeys.recentSearches);
}