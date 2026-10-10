import 'package:flutter/material.dart';
import '../models/student.dart';
import '../state/app_language.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/profile_card.dart';

/// Shows the signed-in student's details and the Log out button.
/// [embedded] = true when used as a tab inside HomeScreen (no own
/// Scaffold/AppBar); false when opened on its own through '/profile'.
class ProfileScreen extends StatelessWidget {
  final bool embedded;

  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final body = ValueListenableBuilder<Student>(
      valueListenable: currentStudentNotifier,
      builder: (context, student, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileCard(student: student, compact: false),
            const SizedBox(height: 24),
            CustomButton(
              label: tr(context, 'logout'),
              onPressed: () => confirmAndLogout(context),
              color: AppColors.blushPink,
              textColor: AppColors.textDark,
            ),
          ],
        );
      },
    );

    if (embedded) return body;
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'studentProfile'))),
      body: body,
    );
  }
}
