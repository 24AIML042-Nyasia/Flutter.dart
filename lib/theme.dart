import 'package:flutter/material.dart';

/// Simple pastel palette used across the app.
class AppColors {
  static const Color lavender = Color(0xFFE6E0F8);
  static const Color mintGreen = Color(0xFFD6F5E3);
  static const Color babyBlue = Color(0xFFDCEEFB);
  static const Color blushPink = Color(0xFFFBE1E8);
  static const Color peach = Color(0xFFFDEBD3);
  static const Color softYellow = Color(0xFFFDF6D8);

  static const Color textDark = Color(0xFF4A4A5A);
  static const Color textMuted = Color(0xFF8A8A9A);

  static const Color primary = Color(0xFFB6A6E8); // pastel purple
  static const Color background = Color(0xFFFAF9FC);

  // Dark mode surfaces
  static const Color darkBackground = Color(0xFF1E1A2B);
  static const Color darkSurface = Color(0xFF2A2440);
  static const Color darkAppBar = Color(0xFF352C4E);
  static const Color darkText = Color(0xFFF2F0F8);
  static const Color darkTextMuted = Color(0xFFC7C0DE);
}

/// Global switch that controls light/dark mode for the whole app.
/// Read by [SmartStudentCompanionApp] and written to by the Settings screen.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.mintGreen,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lavender,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
      fontFamily: 'Roboto',
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

ThemeData buildAppDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.mintGreen,
      surface: AppColors.darkSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkAppBar,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.darkText,
      displayColor: AppColors.darkText,
      fontFamily: 'Roboto',
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
