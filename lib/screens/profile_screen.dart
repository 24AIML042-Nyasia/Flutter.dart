import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_card.dart';
import 'login_screen.dart';

/// StatelessWidget: purely displays the student passed to it, no
/// internal mutable state of its own. Student info only — notifications
/// live on their own screen behind the bell icon.
class ProfileScreen extends StatelessWidget {
  final Student student;

  const ProfileScreen({super.key, required this.student});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Clears the whole navigation stack so Back can't return to the
      // dashboard after logging out.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileCard(student: student, compact: false),
          const SizedBox(height: 24),
          CustomButton(
            label: 'Log out',
            onPressed: () => _confirmLogout(context),
            color: AppColors.blushPink,
            textColor: AppColors.textDark,
          ),
        ],
      ),
    );
  }
}
