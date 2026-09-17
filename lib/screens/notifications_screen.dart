import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/notification_tile.dart';

/// StatelessWidget: just renders the list it's given.
/// Shows notifications only — no student/profile details here.
class NotificationsScreen extends StatelessWidget {
  final List<String> notifications;

  const NotificationsScreen({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No new notifications.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final note in notifications) NotificationTile(note),
              ],
            ),
    );
  }
}
