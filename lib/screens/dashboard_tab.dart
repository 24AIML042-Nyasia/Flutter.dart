import 'package:flutter/material.dart';
import '../models/student.dart';
import '../routes/app_routes.dart';
import '../state/app_language.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/profile_card.dart';

/// The Dashboard tab (body only). The surrounding Scaffold, drawer and
/// bottom navigation live in HomeScreen. Every card opens its screen with a
/// named route.
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Student>(
      valueListenable: currentStudentNotifier,
      builder: (context, student, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCard(
                student: student,
                compact: true,
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profile),
              ),
              const SizedBox(height: 20),
              Text(
                tr(context, 'modules'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              // Rebuilds when the columns slider or module switches change.
              AnimatedBuilder(
                animation: Listenable.merge([
                  dashboardColumnsNotifier,
                  hiddenModulesNotifier,
                ]),
                builder: (context, _) {
                  final columns = dashboardColumnsNotifier.value;
                  final hidden = hiddenModulesNotifier.value;
                  const aspectByColumns = {1: 2.6, 2: 1.15, 3: 0.8};

                  final statusKey = student.attendancePercentage >= 75
                      ? 'goodStanding'
                      : student.attendancePercentage >= 60
                          ? 'warning'
                          : 'detainedRisk';

                  void open(String route) =>
                      Navigator.of(context).pushNamed(route);

                  final modules = <String, DashboardCard>{
                    'attendance': DashboardCard(
                      title: tr(context, 'attendance'),
                      subtitle: tr(context, statusKey),
                      icon: Icons.event_available_rounded,
                      color: AppColors.mintGreen,
                      onTap: () => open(AppRoutes.attendance),
                    ),
                    'timetable': DashboardCard(
                      title: tr(context, 'timetable'),
                      subtitle: student.subjectList(),
                      icon: Icons.calendar_month_rounded,
                      color: AppColors.babyBlue,
                      onTap: () => open(AppRoutes.timetable),
                    ),
                    'assignments': DashboardCard(
                      title: tr(context, 'assignments'),
                      subtitle: tr(context, 'toTrack'),
                      icon: Icons.assignment_rounded,
                      color: AppColors.blushPink,
                      onTap: () => open(AppRoutes.assignments),
                    ),
                    'notes': DashboardCard(
                      title: tr(context, 'notes'),
                      subtitle: tr(context, 'notesSubtitle'),
                      icon: Icons.sticky_note_2_rounded,
                      color: AppColors.babyBlue,
                      onTap: () => open(AppRoutes.notes),
                    ),
                    'tasks': DashboardCard(
                      title: tr(context, 'tasks'),
                      subtitle: tr(context, 'tasksSubtitle'),
                      icon: Icons.task_alt_rounded,
                      color: AppColors.peach,
                      onTap: () => open(AppRoutes.tasks),
                    ),
                    'notices': DashboardCard(
                      title: tr(context, 'notices'),
                      subtitle: tr(context, 'noticesSubtitle'),
                      icon: Icons.campaign_rounded,
                      color: AppColors.mintGreen,
                      onTap: () => open(AppRoutes.notices),
                    ),
                    'faculty': DashboardCard(
                      title: tr(context, 'faculty'),
                      subtitle: tr(context, 'meetTeachers'),
                      icon: Icons.school_rounded,
                      color: AppColors.lavender,
                      onTap: () => open(AppRoutes.faculty),
                    ),
                    'events': DashboardCard(
                      title: tr(context, 'events'),
                      subtitle: tr(context, 'upcomingEvents'),
                      icon: Icons.celebration_rounded,
                      color: AppColors.peach,
                      onTap: () => open(AppRoutes.events),
                    ),
                    'settings': DashboardCard(
                      title: tr(context, 'settings'),
                      subtitle: tr(context, 'preferences'),
                      icon: Icons.settings_rounded,
                      color: AppColors.softYellow,
                      onTap: () => open(AppRoutes.settings),
                    ),
                  };

                  final visible = [
                    for (final entry in modules.entries)
                      if (!hidden.contains(entry.key)) entry.value,
                  ];

                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: aspectByColumns[columns] ?? 1.15,
                    children: visible,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
