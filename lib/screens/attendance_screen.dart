import 'package:flutter/material.dart';
import '../theme.dart';

/// Simple record type for one subject's attendance.
class SubjectAttendance {
  final String subject;
  final double percentage;
  const SubjectAttendance(this.subject, this.percentage);
}

/// StatelessWidget: displays fixed sample attendance data.
/// Demonstrates: Stack (overlaying text on a progress ring), ListView,
/// Row + Expanded (label / bar / percentage laid out together).
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static const List<SubjectAttendance> _records = [
    SubjectAttendance('DBMS', 92),
    SubjectAttendance('MAD', 88),
    SubjectAttendance('AI', 95),
    SubjectAttendance('CN', 90),
  ];

  double get _overall {
    final total = _records.fold<double>(0, (sum, r) => sum + r.percentage);
    return total / _records.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Summary')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: _OverallRing(percentage: _overall)),
          const SizedBox(height: 28),
          const Text(
            'By subject',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          for (final record in _records) _SubjectRow(record: record),
        ],
      ),
    );
  }
}

/// Stack: a circular progress indicator with the percentage text
/// layered on top of it.
class _OverallRing extends StatelessWidget {
  final double percentage;
  const _OverallRing({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 10,
              backgroundColor: AppColors.mintGreen.withOpacity(0.35),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const Text(
                'Overall',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Row + Expanded: subject label, a flexible progress bar, and the
/// percentage all share one row without overflowing.
class _SubjectRow extends StatelessWidget {
  final SubjectAttendance record;
  const _SubjectRow({required this.record});

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
          SizedBox(
            width: 60,
            child: Text(
              record.subject,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: record.percentage / 100,
                minHeight: 10,
                backgroundColor: AppColors.babyBlue.withOpacity(0.4),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${record.percentage.toStringAsFixed(0)}%',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
