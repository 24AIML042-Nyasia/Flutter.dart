import 'package:flutter/material.dart';
import '../models/student.dart';
import '../state/app_language.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/notification_tile.dart';

/// Notifications only, no student/profile details. Respects the
/// Enable notifications switch in Settings.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'notifications'))),
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [currentStudentNotifier, notificationsEnabledNotifier]),
        builder: (context, _) {
          final Student student = currentStudentNotifier.value;
          final enabled = notificationsEnabledNotifier.value;
          final notifications = student.notifications;

          if (!enabled || notifications.isEmpty) {
            return Center(
              child: Text(
                tr(context, enabled ? 'noNotifications' : 'notificationsOff'),
                style: const TextStyle(color: AppColors.textMuted),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [for (final note in notifications) NotificationTile(note)],
          );
        },
      ),
    );
  }
}
