import 'package:flutter/material.dart';

class AppThemeController {
  const AppThemeController._();

  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static bool get isDark => mode.value == ThemeMode.dark;

  static void setDark(bool value) {
    mode.value = value ? ThemeMode.dark : ThemeMode.light;
  }

  static void toggle() => setDark(!isDark);
}

class AppColors {
  const AppColors._();

  static bool get _d => AppThemeController.isDark;

  /// خلفية الشاشة
  static Color get background =>
      _d ? const Color(0xFF0B1220) : const Color(0xFFF4F6F9);

  /// خلفية الكروت (بدل Colors.white)
  static Color get surface =>
      _d ? const Color(0xFF141E2E) : Colors.white;

  /// خلفية داخلية للبلوكات
  static Color get surfaceAlt =>
      _d ? const Color(0xFF1B2740) : const Color(0xFFF4F6F9);

  static Color get border =>
      _d ? const Color(0xFF27344A) : const Color(0xFFE4E7EC);

  static Color get text =>
      _d ? const Color(0xFFE9EEF6) : const Color(0xFF16233A);

  static Color get secondaryText =>
      _d ? const Color(0xFF9AA8BD) : const Color(0xFF6B7280);

  static Color get primary =>
      _d ? const Color(0xFF4D8DFF) : const Color(0xFF2563EB);

  static Color get primaryLight =>
      _d ? const Color(0xFF1C2C4A) : const Color(0xFFE8EEFC);

  static const Color green = Color(0xFF16A34A);

  static const Color red = Color(0xFFDC2626);

  static const Color orange = Color(0xFFF59E0B);

  static const Color field = Color(0xFFF8FAFC);

  static const List<Color> heroGradient = [
    Color(0xFF16233A),
    Color(0xFF23364F),
  ];
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final surface = isDark ? const Color(0xFF141E2E) : Colors.white;
    final bg = isDark ? const Color(0xFF0B1220) : const Color(0xFFF4F6F9);
    final txt = isDark ? const Color(0xFFE9EEF6) : const Color(0xFF16233A);
    final sub = isDark ? const Color(0xFF9AA8BD) : const Color(0xFF6B7280);
    final brd = isDark ? const Color(0xFF27344A) : const Color(0xFFE4E7EC);
    final pri = isDark ? const Color(0xFF4D8DFF) : const Color(0xFF2563EB);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      cardColor: surface,
      dividerColor: brd,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pri,
        brightness: brightness,
        surface: surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: txt,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: Typography.material2021()
          .black
          .apply(bodyColor: txt, displayColor: txt),
      iconTheme: IconThemeData(color: txt),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: sub, fontSize: 12.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        prefixIconColor: sub,
        suffixIconColor: sub,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: brd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: brd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: pri, width: 1.4),
        ),
      ),
    );
  }
}