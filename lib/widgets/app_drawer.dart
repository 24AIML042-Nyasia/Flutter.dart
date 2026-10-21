import 'package:flutter/material.dart';
import '../models/student.dart';
import '../routes/app_routes.dart';
import '../services/prefs_service.dart';
import '../state/app_language.dart';
import '../state/app_state.dart';
import '../theme.dart';
import 'logout_dialog.dart';

/// Side drawer. Items that are also bottom-navigation tabs switch the tab;
/// the rest open their screen with a named route.
class AppDrawer extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSelectTab;

  const AppDrawer({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ValueListenableBuilder<Student>(
        valueListenable: currentStudentNotifier,
        builder: (context, student, _) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.lavender),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: AppColors.primary, size: 30),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      PrefsService.username ?? student.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              _tab(context, 0, Icons.dashboard_rounded, 'dashboard'),
              _tab(context, 1, Icons.event_available_rounded, 'attendance'),
              _tab(context, 2, Icons.calendar_month_rounded, 'timetable'),
              _tab(context, 3, Icons.person_rounded, 'profile'),
              const Divider(),
              _route(context, Icons.assignment_rounded, 'assignments', AppRoutes.assignments),
              _route(context, Icons.sticky_note_2_rounded, 'notes', AppRoutes.notes),
              _route(context, Icons.task_alt_rounded, 'tasks', AppRoutes.tasks),
              _route(context, Icons.campaign_rounded, 'notices', AppRoutes.notices),
              _route(context, Icons.feedback_outlined, 'feedback', AppRoutes.feedback),
              _route(context, Icons.celebration_rounded, 'events', AppRoutes.events),
              _route(context, Icons.school_rounded, 'faculty', AppRoutes.faculty),
              _route(context, Icons.notifications_rounded, 'notifications', AppRoutes.notifications),
              _route(context, Icons.settings_rounded, 'settings', AppRoutes.settings),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: Text(
                  tr(context, 'logout'),
                  style: const TextStyle(color: Colors.redAccent),
                ),
                // Drawer stays open so its context is still valid for the dialog.
                onTap: () => confirmAndLogout(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tab(BuildContext context, int index, IconData icon, String key) {
    return ListTile(
      leading: Icon(icon),
      title: Text(tr(context, key)),
      selected: currentTab == index,
      selectedColor: AppColors.primary,
      onTap: () {
        Navigator.of(context).pop(); // close the drawer
        onSelectTab(index);
      },
    );
  }

  Widget _route(BuildContext context, IconData icon, String key, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(tr(context, key)),
      onTap: () {
        Navigator.of(context).pop(); // close the drawer
        Navigator.of(context).pushNamed(route);
      },
    );
  }
}
