import 'package:flutter/material.dart';

import '../models/student.dart';
import '../theme.dart';
import '../widgets/dashboard_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = Student(
      name: 'Rahul Patel',
      email: 'rahul.patel@college.edu',
      enrollmentNo: '24CE001',
      department: 'Computer Engineering',
      semester: 5,
      cgpa: 8.9,
      attendancePercentage: 91,
      subjects: ['MAD', 'DBMS', 'AI', 'CN'],
    );

    final notifications = [
      'Assignment submission',
      'Event registration',
      'Examination schedule',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Student Companion')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileCard(student: student),
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
                  subtitle: '${student.attendancePercentage}% attendance',
                  icon: Icons.event_available_rounded,
                  color: AppColors.mintGreen,
                ),
                DashboardCard(
                  title: 'Courses',
                  subtitle: student.subjectList(),
                  icon: Icons.menu_book_rounded,
                  color: AppColors.babyBlue,
                ),
                const DashboardCard(
                  title: 'Assignments',
                  subtitle: 'Submission due this week',
                  icon: Icons.assignment_rounded,
                  color: AppColors.blushPink,
                ),
                DashboardCard(
                  title: 'Notifications',
                  subtitle: notifications.join(', '),
                  icon: Icons.notifications_rounded,
                  color: AppColors.peach,
                ),
                const DashboardCard(
                  title: 'Events',
                  subtitle: 'Tech fest • 2 days left',
                  icon: Icons.celebration_rounded,
                  color: AppColors.softYellow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Student student;
  const _ProfileCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 34, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Student ID: ${student.enrollmentNo} • ${student.department}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Semester ${student.semester} • Attendance ${student.attendancePercentage}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
