import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';
import 'services/prefs_service.dart';
import 'state/app_language.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // In a browser, SQLite runs through the web database factory.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  // Load saved login/theme/language/etc. before the first screen is drawn.
  await PrefsService.init();
  runApp(const SmartStudentCompanionApp());
}

class SmartStudentCompanionApp extends StatelessWidget {
  const SmartStudentCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds when the Settings screen flips themeModeNotifier (dark mode).
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Smart Student Companion',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildAppDarkTheme(),
          themeMode: mode,
          // LanguageScope sits above every screen, so changing
          // languageNotifier re-translates the whole app instantly.
          builder: (context, child) {
            return ValueListenableBuilder<String>(
              valueListenable: languageNotifier,
              builder: (context, language, _) =>
                  LanguageScope(language: language, child: child!),
            );
          },
          initialRoute: AppRoutes.splash,
          onGenerateRoute: generateRoute,
        );
      },
    );
  }
}
