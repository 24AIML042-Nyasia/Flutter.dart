import 'package:flutter/material.dart';
import '../models/student.dart';

// ---------------------------------------------------------------------------
// APPLICATION STATE
// Values here are shared by several screens. When one screen changes them,
// every screen listening to them rebuilds immediately — no restart, no
// navigating back and forth. (State that only one widget cares about is
// "Ephemeral State" and lives inside that widget's State class instead.)
// The theme mode (themeModeNotifier in theme.dart) is the third shared value.
// ---------------------------------------------------------------------------

/// The signed-in student's profile. Edited on the Settings screen, read by
/// the Dashboard (profile card, bell badge, status text).
Student buildDefaultStudent() => Student(
      name: 'Rahul Patel',
      email: 'rahul.patel@charusat.edu.in',
      enrollmentNo: '24CE001',
      department: 'Computer Engineering',
      semester: 5,
      cgpa: 8.2,
      attendancePercentage: 91,
      subjects: ['MAD', 'DBMS', 'AI', 'CN'],
      notifications: const [
        'Internal exam schedule released',
        'Assignment deadline approaching',
        'Technical event registration open',
      ],
    );

final ValueNotifier<Student> currentStudentNotifier =
    ValueNotifier(buildDefaultStudent());

/// Master switch for notifications (Enabled / Disabled in Settings).
final ValueNotifier<bool> notificationsEnabledNotifier = ValueNotifier(true);

/// How many cards appear per row on the dashboard (1 to 3).
/// Changed with a Slider on the Settings screen.
final ValueNotifier<int> dashboardColumnsNotifier = ValueNotifier(2);

/// Ids of dashboard modules the student has switched off in Settings.
/// ('settings' can never be hidden, so Settings is always reachable.)
final ValueNotifier<Set<String>> hiddenModulesNotifier =
    ValueNotifier<Set<String>>({});
