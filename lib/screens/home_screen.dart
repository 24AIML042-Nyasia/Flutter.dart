import 'package:flutter/material.dart';
import '../state/app_language.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/notification_bell.dart';
import 'attendance_screen.dart';
import 'dashboard_tab.dart';
import 'profile_screen.dart';
import 'timetable_screen.dart';

/// Main screen after login (route '/home'). Combines:
///  - a Drawer (side menu) for every module,
///  - a BottomNavigationBar for the four main tabs,
///  - an IndexedStack that keeps each tab alive while you switch.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0; // currently selected tab (ephemeral state)

  static const List<String> _titleKeys = [
    'dashboardTitle',
    'attendance',
    'timetable',
    'studentProfile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, _titleKeys[_index])),
        actions: const [NotificationBell(), SizedBox(width: 8)],
      ),
      drawer: AppDrawer(
        currentTab: _index,
        onSelectTab: (i) => setState(() => _index = i),
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          DashboardTab(),
          AttendanceScreen(embedded: true),
          TimetableScreen(embedded: true),
          ProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_rounded),
            label: tr(context, 'dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event_available_rounded),
            label: tr(context, 'attendance'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_rounded),
            label: tr(context, 'timetable'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: tr(context, 'profile'),
          ),
        ],
      ),
    );
  }
}
