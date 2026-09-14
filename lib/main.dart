import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/routing/app_router.dart';
import 'core/services/app_settings.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';

void main() async {



   ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFFFFF4F4),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Text(
          '${details.exception}\n\n${details.stack}',
          style: const TextStyle(fontSize: 10, color: Colors.red),
        ),
      ),
    );
  };

  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const LogiTrackApp());
}

class LogiTrackApp extends StatefulWidget {
  const LogiTrackApp({super.key});

  @override
  State<LogiTrackApp> createState() => _LogiTrackAppState();
}

class _LogiTrackAppState extends State<LogiTrackApp> {
  late final AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings();
  }

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      notifier: _settings,
      child: AnimatedBuilder(
        animation: _settings,
        builder: (context, _) {
          return MaterialApp(
            title: AppConstants.appFullName,
            debugShowCheckedModeBanner: false,

            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: _settings.themeMode,

            locale: _settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              return supportedLocales.firstWhere(
                (supportedLocale) =>
                    supportedLocale.languageCode == locale?.languageCode,
                orElse: () => supportedLocales.first,
              );
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
            onUnknownRoute: AppRouter.unknownRoute,
          );
        },
      ),
    );
  }
}