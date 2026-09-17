import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme.dart';

/// Reusable card that shows a student's key details.
/// [compact] = true -> short version used on the dashboard.
/// [compact] = false -> full version used on the Student Profile screen.
class ProfileCard extends StatelessWidget {
  final Student student;
  final bool compact;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.student,
    this.compact = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lavender,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                        student.describe(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${student.enrollmentNo} • CGPA ${student.cgpa}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (compact) const Icon(Icons.chevron_right, color: AppColors.textMuted),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white),
              const SizedBox(height: 8),
              _detailRow('Email', student.email),
              _detailRow('Semester', student.semester.toString()),
              _detailRow('Attendance',
                  '${student.attendancePercentage.toStringAsFixed(0)}% (${student.attendanceStatus()})'),
              _detailRow('Subjects', student.subjectList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
