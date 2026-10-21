import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';
import '../theme.dart';
import '../utils/date_utils.dart';
import '../widgets/app_snack.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

/// Add or edit a note. Opened with the named route '/note-form'; the route
/// argument is the Note to edit (or null to add a new one).
/// Pops with a success message so the list can reload and show it.
class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _subject = Note.subjects.first;
  Note? _editing;
  bool _loaded = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Note) {
      _editing = args;
      _titleController.text = args.title;
      _descriptionController.text = args.description;
      _subject = args.subject;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final note = Note(
        id: _editing?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        subject: _subject,
        createdDate: _editing?.createdDate ?? todayIso(),
      );
      if (_editing == null) {
        await DatabaseHelper.instance.insertNote(note);
      } else {
        await DatabaseHelper.instance.updateNote(note);
      }
      if (!mounted) return;
      Navigator.of(context).pop(_editing == null ? 'Note added' : 'Note updated');
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnack(context, 'Could not save the note. Please try again.', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text(_editing == null ? 'Add Note' : 'Edit Note')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CustomTextField(
                controller: _titleController,
                label: 'Title',
                icon: Icons.title_rounded,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter a title';
                  if (value.length < 3) return 'Title must be at least 3 characters';
                  if (value.length > 60) return 'Title must be 60 characters or fewer';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _subject,
                isExpanded: true,
                dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                style: TextStyle(color: isDark ? AppColors.darkText : AppColors.textDark, fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: TextStyle(
                    color: isDark ? AppColors.darkTextMuted : AppColors.textDark,
                  ),
                  prefixIcon: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  for (final s in Note.subjects)
                    DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (v) => setState(() => _subject = v ?? _subject),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.notes_rounded,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter a description';
                  if (value.length < 5) return 'Description is too short';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: _saving ? 'Saving...' : (_editing == null ? 'Save note' : 'Update note'),
                onPressed: _saving ? () {} : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
