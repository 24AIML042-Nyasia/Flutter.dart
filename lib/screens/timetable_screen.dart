import 'package:flutter/material.dart';
import '../theme.dart';

class _Slot {
  final String time;
  final String subject;
  const _Slot(this.time, this.subject);
}

class _DaySchedule {
  final String day;
  final List<_Slot> slots;
  const _DaySchedule(this.day, this.slots);
}

/// StatelessWidget: fixed sample weekly timetable.
/// Demonstrates: ListView (scrollable list of day cards), Column (slots
/// stacked inside each day), Row (time + subject side by side).
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static const List<_DaySchedule> _week = [
    _DaySchedule('Monday', [
      _Slot('9:00 AM', 'DBMS'),
      _Slot('11:00 AM', 'MAD'),
      _Slot('2:00 PM', 'AI'),
    ]),
    _DaySchedule('Tuesday', [
      _Slot('9:00 AM', 'CN'),
      _Slot('11:00 AM', 'DBMS'),
    ]),
    _DaySchedule('Wednesday', [
      _Slot('10:00 AM', 'AI'),
      _Slot('1:00 PM', 'MAD'),
      _Slot('3:00 PM', 'CN'),
    ]),
    _DaySchedule('Thursday', [
      _Slot('9:00 AM', 'MAD'),
      _Slot('12:00 PM', 'DBMS'),
    ]),
    _DaySchedule('Friday', [
      _Slot('10:00 AM', 'CN'),
      _Slot('1:00 PM', 'AI'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [for (final day in _week) _DayCard(day: day)],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final _DaySchedule day;
  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.babyBlue,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.day,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          for (final slot in day.slots)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      slot.time,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      slot.subject,
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
