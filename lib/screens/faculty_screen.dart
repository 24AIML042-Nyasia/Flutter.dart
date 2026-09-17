import 'package:flutter/material.dart';
import '../theme.dart';

class FacultyMember {
  final String name;
  final String subject;
  final String designation;
  const FacultyMember(this.name, this.subject, this.designation);
}

/// StatelessWidget: fixed sample faculty data.
/// Demonstrates ListView for a linear, detail-heavy list — chosen over
/// GridView here because each row needs more horizontal room for text
/// than a grid tile would give it (see Event Gallery for the GridView case).
class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});

  static const List<FacultyMember> _faculty = [
    FacultyMember('Dr. Ananya Iyer', 'DBMS', 'Associate Professor'),
    FacultyMember('Prof. Karan Shah', 'MAD', 'Assistant Professor'),
    FacultyMember('Dr. Meera Nair', 'AI', 'Professor'),
    FacultyMember('Prof. Sameer Joshi', 'CN', 'Assistant Professor'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Faculty Information')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _faculty.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _FacultyTile(member: _faculty[index]),
      ),
    );
  }
}

class _FacultyTile extends StatelessWidget {
  final FacultyMember member;
  const _FacultyTile({required this.member});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lavender,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  '${member.designation} • ${member.subject}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
