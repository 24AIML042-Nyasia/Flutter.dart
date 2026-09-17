import 'package:flutter/material.dart';
import '../theme.dart';

enum AssignmentStatus { pending, dueSoon, submitted }

class Assignment {
  final String title;
  final String subject;
  final AssignmentStatus status;
  final String dueLabel;
  const Assignment(this.title, this.subject, this.status, this.dueLabel);
}

/// StatelessWidget: fixed sample assignment data.
/// Demonstrates: ListView, Row (icon + text + status chip), Column
/// (title + subtitle stacked), Expanded (title takes remaining space).
class AssignmentListScreen extends StatelessWidget {
  const AssignmentListScreen({super.key});

  static const List<Assignment> _assignments = [
    Assignment('Flutter UI Design', 'MAD', AssignmentStatus.dueSoon, 'Due in 2 days'),
    Assignment('Database CRUD', 'DBMS', AssignmentStatus.pending, 'Due in 5 days'),
    Assignment('REST API Integration', 'MAD', AssignmentStatus.submitted, 'Submitted'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [for (final a in _assignments) _AssignmentTile(assignment: a)],
      ),
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final Assignment assignment;
  const _AssignmentTile({required this.assignment});

  Color _statusColor() {
    switch (assignment.status) {
      case AssignmentStatus.submitted:
        return AppColors.mintGreen;
      case AssignmentStatus.dueSoon:
        return AppColors.blushPink;
      case AssignmentStatus.pending:
        return AppColors.softYellow;
    }
  }

  String _statusLabel() {
    switch (assignment.status) {
      case AssignmentStatus.submitted:
        return 'Submitted';
      case AssignmentStatus.dueSoon:
        return 'Due soon';
      case AssignmentStatus.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _statusColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.assignment_rounded, color: AppColors.textDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${assignment.subject} • ${assignment.dueLabel}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statusLabel(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
