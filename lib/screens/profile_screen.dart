import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/profile_card.dart';

/// StatelessWidget: purely displays the student passed to it, no
/// internal mutable state of its own. Student info only — notifications
/// live on their own screen behind the bell icon.
class ProfileScreen extends StatelessWidget {
  final Student student;

  const ProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileCard(student: student, compact: false),
        ],
      ),
    );
  }
}
