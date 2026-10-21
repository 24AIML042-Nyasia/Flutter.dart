import 'package:flutter/material.dart';
import '../theme.dart';

/// Search box used above the notes and tasks lists.
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      style: TextStyle(color: isDark ? AppColors.darkText : AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  onChanged();
                },
              ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
