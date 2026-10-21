import 'package:flutter/material.dart';
import '../models/task.dart';
import '../routes/app_routes.dart';
import '../services/database_helper.dart';
import '../state/app_language.dart';
import '../theme.dart';
import '../utils/date_utils.dart';
import '../widgets/app_snack.dart';
import '../widgets/db_error_view.dart';
import '../widgets/search_field.dart';

/// Task Manager: view, search, sort, filter, add, edit, complete, delete.
/// Same FutureBuilder pattern as the Notes screen.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _searchController = TextEditingController();
  TaskSort _sort = TaskSort.dueDate;
  TaskFilter _filter = TaskFilter.all;
  late Future<List<Task>> _tasksFuture;

  static const Map<TaskSort, String> _sortLabels = {
    TaskSort.dueDate: 'Due date',
    TaskSort.priority: 'Priority',
    TaskSort.name: 'Name A-Z',
  };

  static const Map<TaskFilter, String> _filterLabels = {
    TaskFilter.all: 'All',
    TaskFilter.pending: 'Pending',
    TaskFilter.completed: 'Completed',
  };

  @override
  void initState() {
    super.initState();
    _tasksFuture = _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Task>> _load() => DatabaseHelper.instance.getTasks(
        search: _searchController.text,
        sort: _sort,
        filter: _filter,
      );

  void _reload() => setState(() => _tasksFuture = _load());

  Future<void> _openForm([Task? task]) async {
    final result =
        await Navigator.of(context).pushNamed(AppRoutes.taskForm, arguments: task);
    if (result is String && mounted) {
      _reload();
      showAppSnack(context, result);
    }
  }

  Future<void> _toggleDone(Task task, bool done) async {
    try {
      await DatabaseHelper.instance.updateTask(
        task.copyWith(status: done ? Task.completed : Task.pending),
      );
      if (!mounted) return;
      _reload();
      showAppSnack(context, done ? 'Task marked completed' : 'Task marked pending');
    } catch (_) {
      if (mounted) showAppSnack(context, 'Could not update the task', error: true);
    }
  }

  Future<void> _delete(Task task) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete task?',
      message: '"${task.name}" will be removed permanently.',
    );
    if (!ok || !mounted) return;
    try {
      await DatabaseHelper.instance.deleteTask(task.id!);
      if (!mounted) return;
      _reload();
      showAppSnack(context, 'Task deleted');
    } catch (_) {
      if (mounted) showAppSnack(context, 'Could not delete the task', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'tasks'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add task'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _searchController,
                    hint: 'Search tasks',
                    onChanged: _reload,
                  ),
                ),
                PopupMenuButton<TaskSort>(
                  icon: const Icon(Icons.sort_rounded),
                  tooltip: 'Sort',
                  initialValue: _sort,
                  onSelected: (value) {
                    _sort = value;
                    _reload();
                  },
                  itemBuilder: (_) => [
                    for (final entry in _sortLabels.entries)
                      PopupMenuItem(value: entry.key, child: Text(entry.value)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                for (final entry in _filterLabels.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(entry.value),
                      selected: _filter == entry.key,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: _filter == entry.key ? Colors.white : null,
                      ),
                      onSelected: (_) {
                        _filter = entry.key;
                        _reload();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return DbErrorView(error: snapshot.error, onRetry: _reload);
                }
                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks found.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: tasks.length,
                  itemBuilder: (context, i) => _TaskTile(
                    task: tasks[i],
                    onTap: () => _openForm(tasks[i]),
                    onToggle: (done) => _toggleDone(tasks[i], done),
                    onDelete: () => _delete(tasks[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _TaskTile({
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  Color _priorityColor() {
    switch (task.priority) {
      case 'High':
        return AppColors.blushPink;
      case 'Medium':
        return AppColors.peach;
      default:
        return AppColors.mintGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final overdue = !task.isCompleted && task.dueDate.compareTo(todayIso()) < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                activeColor: AppColors.primary,
                onChanged: (v) => onToggle(v ?? false),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        decoration:
                            task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      overdue
                          ? 'Overdue • ${formatDate(task.dueDate)}'
                          : 'Due ${formatDate(task.dueDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: overdue
                            ? Colors.redAccent
                            : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _priorityColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.priority,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                tooltip: 'Delete',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
