/// Names of every screen. Using constants (not typed-out strings) avoids
/// typos when calling Navigator.pushNamed().
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home'; // main shell: Drawer + Bottom Navigation
  static const profile = '/profile';
  static const attendance = '/attendance';
  static const timetable = '/timetable';
  static const assignments = '/assignments';
  static const events = '/events';
  static const faculty = '/faculty';
  static const settings = '/settings';
  static const notifications = '/notifications';
}
