import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/profile_card.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// StatelessWidget: the dashboard just lays out data it's given —
/// no internal mutable state of its own.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for this practical (dataset given in the brief)
    final student = Student(
      name: 'Rahul Patel',
      email: 'rahul.patel@university.edu',
      enrollmentNo: '24CE001',
      department: 'Computer Engineering',
      semester: 5,
      cgpa: 8.2,
      attendancePercentage: 91,
      subjects: ['MAD', 'DBMS', 'AI', 'CN'],
      notifications: const [
        'Assignment submission due Friday',
        'Event registration open for Tech Fest',
        'Examination schedule released',
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Student Companion'),
        actions: [
          _NotificationBellButton(notifications: student.notifications),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(
              student: student,
              compact: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProfileScreen(student: student)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.15,
              children: [
                DashboardCard(
                  title: 'Attendance',
                  subtitle: student.attendanceStatus(),
                  icon: Icons.event_available_rounded,
                  color: AppColors.mintGreen,
                ),
                DashboardCard(
                  title: 'Timetable',
                  subtitle: student.subjectList(),
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.babyBlue,
                ),
                DashboardCard(
                  title: 'Assignments',
                  subtitle: '2 pending',
                  icon: Icons.assignment_rounded,
                  color: AppColors.blushPink,
                ),
                DashboardCard(
                  title: 'Notes',
                  subtitle: '5 subjects',
                  icon: Icons.sticky_note_2_rounded,
                  color: AppColors.softYellow,
                ),
                DashboardCard(
                  title: 'Events',
                  subtitle: 'Tech fest — 2 days left',
                  icon: Icons.celebration_rounded,
                  color: AppColors.peach,
                ),
                DashboardCard(
                  title: 'Settings',
                  subtitle: 'Preferences',
                  icon: Icons.settings_rounded,
                  color: AppColors.mintGreen,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bell icon with a small badge showing how many notifications are unread.
/// Lives in the top app bar, opens a notifications-only screen.
class _NotificationBellButton extends StatelessWidget {
  final List<String> notifications;
  const _NotificationBellButton({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_rounded),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NotificationsScreen(notifications: notifications),
            ),
          ),
        ),
        if (notifications.isNotEmpty)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '${notifications.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
