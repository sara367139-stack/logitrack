class AppConstants {
  AppConstants._();

  static const String appName = 'LogiTrack';
  static const String appFullName = 'LogiTrack WMS';
  static const String appTagline = 'Enterprise Inventory & Warehouse Mobility';
  static const String appVersion = 'v4.8.2';
  static const String defaultWarehouse = 'WH-North Bay Hub';
  static const String apiBaseUrl = String.fromEnvironment(
    'LOGITRACK_API_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );
}

class StorageKeys {
  StorageKeys._();

  static const String onboardingSeen = 'onboarding_seen';
  static const String isLoggedIn = 'is_logged_in';
  static const String userName = 'user_name';
  static const String userBadge = 'user_badge';
  static const String rememberMe = 'remember_me';
  static const String languageCode = 'language_code';
  static const String recentSearches = 'recent_searches';
  static const String warehouse = 'warehouse';
  static const String darkMode = 'dark_mode';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}
