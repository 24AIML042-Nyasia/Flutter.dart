import 'package:flutter/material.dart';
import '../models/student.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';

/// Bell icon for the app bar with an unread-count badge. The badge hides
/// when notifications are disabled in Settings.
class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([currentStudentNotifier, notificationsEnabledNotifier]),
      builder: (context, _) {
        final Student student = currentStudentNotifier.value;
        final count = student.notifications.length;
        final showBadge = notificationsEnabledNotifier.value && count > 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_rounded),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.notifications),
            ),
            if (showBadge)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$count',
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
      },
    );
  }
}
