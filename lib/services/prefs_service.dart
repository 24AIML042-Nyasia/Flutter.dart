import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student.dart';
import '../state/app_language.dart';
import '../state/app_state.dart';
import '../theme.dart';

/// Persistent storage built on Shared Preferences (key-value pairs saved on
/// the device, so they survive closing and restarting the app).
///
/// Stored: login status, username, theme, language, semester (plus the other
/// profile fields), notification settings, and dashboard customization.
class PrefsService {
  PrefsService._();

  static late SharedPreferences _prefs;
  static bool _listening = false;
  static bool _paused = false; // true while logout resets the notifiers

  // Sample login from the practical's dataset.
  static const String demoUsername = 'rahul.patel@charusat.edu.in';
  static const String demoPassword = 'student@123';

  // Keys
  static const _kLoggedIn = 'logged_in';
  static const _kUsername = 'username';
  static const _kTheme = 'theme_mode';
  static const _kLanguage = 'language';
  static const _kSemester = 'semester';
  static const _kName = 'profile_name';
  static const _kEnrollment = 'profile_enrollment';
  static const _kDepartment = 'profile_department';
  static const _kNotificationsEnabled = 'notifications_enabled';
  static const _kColumns = 'dashboard_columns';
  static const _kHidden = 'hidden_modules';

  /// Call once before runApp(): opens storage and restores saved settings
  /// into the app's notifiers, so the app starts exactly as it was left.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _restore();
    if (!_listening) {
      _listening = true;
      _saveWhenChanged();
    }
  }

  // ---------------- Session ----------------

  static bool get isLoggedIn => _prefs.getBool(_kLoggedIn) ?? false;
  static String? get username => _prefs.getString(_kUsername);

  static bool checkCredentials(String username, String password) {
    return username.trim().toLowerCase() == demoUsername &&
        password == demoPassword;
  }

  static Future<void> login(String username) async {
    final name = username.trim().toLowerCase();
    await _prefs.setBool(_kLoggedIn, true);
    await _prefs.setString(_kUsername, name);
    final s = currentStudentNotifier.value;
    currentStudentNotifier.value = _copy(s, email: name);
  }

  /// Logout: reset the app to defaults, then wipe everything stored.
  static Future<void> logout() async {
    _paused = true;
    themeModeNotifier.value = ThemeMode.light;
    languageNotifier.value = 'English';
    notificationsEnabledNotifier.value = true;
    dashboardColumnsNotifier.value = 2;
    hiddenModulesNotifier.value = <String>{};
    currentStudentNotifier.value = buildDefaultStudent();
    await _prefs.clear();
    _paused = false;
  }

  // ---------------- Profile ----------------

  static Future<void> saveProfile(Student s) async {
    await _prefs.setString(_kName, s.name);
    await _prefs.setString(_kEnrollment, s.enrollmentNo);
    await _prefs.setString(_kDepartment, s.department);
    await _prefs.setInt(_kSemester, s.semester);
  }

  // ---------------- Checkbox preferences ----------------

  static bool getBool(String key, bool fallback) =>
      _prefs.getBool(key) ?? fallback;

  static Future<void> setBool(String key, bool value) =>
      _prefs.setBool(key, value);

  // ---------------- Internals ----------------

  static Student _copy(Student s,
      {String? name,
      String? email,
      String? enrollmentNo,
      String? department,
      int? semester}) {
    return Student(
      name: name ?? s.name,
      email: email ?? s.email,
      enrollmentNo: enrollmentNo ?? s.enrollmentNo,
      department: department ?? s.department,
      semester: semester ?? s.semester,
      cgpa: s.cgpa,
      attendancePercentage: s.attendancePercentage,
      subjects: s.subjects,
      notifications: s.notifications,
    );
  }

  static void _restore() {
    themeModeNotifier.value =
        _prefs.getString(_kTheme) == 'dark' ? ThemeMode.dark : ThemeMode.light;

    final lang = _prefs.getString(_kLanguage);
    languageNotifier.value =
        (lang != null && appLanguages.contains(lang)) ? lang : 'English';

    notificationsEnabledNotifier.value =
        _prefs.getBool(_kNotificationsEnabled) ?? true;
    dashboardColumnsNotifier.value =
        (_prefs.getInt(_kColumns) ?? 2).clamp(1, 3).toInt();
    hiddenModulesNotifier.value =
        (_prefs.getStringList(_kHidden) ?? <String>[]).toSet();

    currentStudentNotifier.value = _copy(
      buildDefaultStudent(),
      name: _prefs.getString(_kName),
      email: _prefs.getString(_kUsername),
      enrollmentNo: _prefs.getString(_kEnrollment),
      department: _prefs.getString(_kDepartment),
      semester: _prefs.getInt(_kSemester),
    );
  }

  /// Every time a shared setting changes anywhere in the app, save it.
  static void _saveWhenChanged() {
    themeModeNotifier.addListener(() {
      if (_paused) return;
      _prefs.setString(
          _kTheme, themeModeNotifier.value == ThemeMode.dark ? 'dark' : 'light');
    });
    languageNotifier.addListener(() {
      if (_paused) return;
      _prefs.setString(_kLanguage, languageNotifier.value);
    });
    notificationsEnabledNotifier.addListener(() {
      if (_paused) return;
      _prefs.setBool(_kNotificationsEnabled, notificationsEnabledNotifier.value);
    });
    dashboardColumnsNotifier.addListener(() {
      if (_paused) return;
      _prefs.setInt(_kColumns, dashboardColumnsNotifier.value);
    });
    hiddenModulesNotifier.addListener(() {
      if (_paused) return;
      _prefs.setStringList(_kHidden, hiddenModulesNotifier.value.toList());
    });
  }
}
