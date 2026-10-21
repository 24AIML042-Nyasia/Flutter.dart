import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/database_helper.dart';
import '../theme.dart';
import '../utils/date_utils.dart';
import '../widgets/app_snack.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

/// Add or edit a task. Opened with the named route '/task-form'; the route
/// argument is the Task to edit (or null to add a new one).
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dueDateController = TextEditingController();
  String _dueIso = '';
  String _priority = 'Medium';
  String _status = Task.pending;
  Task? _editing;
  bool _loaded = false;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Task) {
      _editing = args;
      _nameController.text = args.name;
      _dueIso = args.dueDate;
      _dueDateController.text = formatDate(args.dueDate);
      _priority = args.priority;
      _status = args.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_dueIso) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _dueIso = dateToIso(picked);
        _dueDateController.text = formatDate(_dueIso);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final task = Task(
        id: _editing?.id,
        name: _nameController.text.trim(),
        dueDate: _dueIso,
        priority: _priority,
        status: _status,
      );
      if (_editing == null) {
        await DatabaseHelper.instance.insertTask(task);
      } else {
        await DatabaseHelper.instance.updateTask(task);
      }
      if (!mounted) return;
      Navigator.of(context).pop(_editing == null ? 'Task added' : 'Task updated');
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showAppSnack(context, 'Could not save the task. Please try again.', error: true);
    }
  }

  InputDecoration _decoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? AppColors.darkTextMuted : AppColors.textDark,
      ),
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldStyle = TextStyle(
      color: isDark ? AppColors.darkText : AppColors.textDark,
      fontSize: 16,
    );
    final menuColor = isDark ? AppColors.darkSurface : Colors.white;

    return Scaffold(
      appBar: AppBar(title: Text(_editing == null ? 'Add Task' : 'Edit Task')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Task name',
                icon: Icons.task_alt_rounded,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Please enter a task name';
                  if (value.length < 3) return 'Task name must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _dueDateController,
                label: 'Due date',
                icon: Icons.event_rounded,
                readOnly: true,
                onTap: _pickDate,
                validator: (_) =>
                    _dueIso.isEmpty ? 'Please choose a due date' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                dropdownColor: menuColor,
                style: fieldStyle,
                decoration: _decoration('Priority', Icons.flag_rounded, isDark),
                items: [
                  for (final p in Task.priorities)
                    DropdownMenuItem(value: p, child: Text(p)),
                ],
                onChanged: (v) => setState(() => _priority = v ?? _priority),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                dropdownColor: menuColor,
                style: fieldStyle,
                decoration: _decoration('Status', Icons.check_circle_outline_rounded, isDark),
                items: const [
                  DropdownMenuItem(value: Task.pending, child: Text(Task.pending)),
                  DropdownMenuItem(value: Task.completed, child: Text(Task.completed)),
                ],
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: _saving ? 'Saving...' : (_editing == null ? 'Save task' : 'Update task'),
                onPressed: _saving ? () {} : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
