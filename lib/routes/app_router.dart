import 'package:flutter/material.dart';
import '../screens/assignment_list_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/event_gallery_screen.dart';
import '../screens/faculty_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/timetable_screen.dart';
import 'app_routes.dart';

/// Route table: route name -> screen.
final Map<String, WidgetBuilder> _routes = {
  AppRoutes.splash: (_) => const SplashScreen(),
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.register: (_) => const RegistrationScreen(),
  AppRoutes.home: (_) => const HomeScreen(),
  AppRoutes.profile: (_) => const ProfileScreen(),
  AppRoutes.attendance: (_) => const AttendanceScreen(),
  AppRoutes.timetable: (_) => const TimetableScreen(),
  AppRoutes.assignments: (_) => const AssignmentListScreen(),
  AppRoutes.events: (_) => const EventGalleryScreen(),
  AppRoutes.faculty: (_) => const FacultyScreen(),
  AppRoutes.settings: (_) => const SettingsScreen(),
  AppRoutes.notifications: (_) => const NotificationsScreen(),
};

/// Called by MaterialApp (onGenerateRoute) for every named navigation.
/// Builds the page with an animated slide + fade transition.
Route<dynamic> generateRoute(RouteSettings settings) {
  final builder = _routes[settings.name] ?? _routes[AppRoutes.login]!;
  return PageRouteBuilder<void>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, _, __) => builder(context),
    transitionsBuilder: (context, animation, _, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0.12, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        position: animation.drive(slide),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
