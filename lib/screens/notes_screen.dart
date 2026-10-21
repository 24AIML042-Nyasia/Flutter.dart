import 'package:flutter/material.dart';
import '../models/note.dart';
import '../routes/app_routes.dart';
import '../services/database_helper.dart';
import '../state/app_language.dart';
import '../theme.dart';
import '../utils/date_utils.dart';
import '../widgets/app_snack.dart';
import '../widgets/db_error_view.dart';
import '../widgets/search_field.dart';

/// Student Notes: view, search, sort, add, edit and delete.
///
/// The list is loaded asynchronously: [_notesFuture] holds the pending
/// database query and a FutureBuilder shows a spinner, an error, an empty
/// message or the list depending on the Future's state.
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _searchController = TextEditingController();
  NoteSort _sort = NoteSort.newest;
  late Future<List<Note>> _notesFuture;

  static const Map<NoteSort, String> _sortLabels = {
    NoteSort.newest: 'Newest first',
    NoteSort.oldest: 'Oldest first',
    NoteSort.titleAZ: 'Title A-Z',
    NoteSort.subject: 'Subject',
  };

  @override
  void initState() {
    super.initState();
    _notesFuture = _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Note>> _load() => DatabaseHelper.instance
      .getNotes(search: _searchController.text, sort: _sort);

  /// Starts a new query; FutureBuilder rebuilds with the fresh result.
  void _reload() => setState(() => _notesFuture = _load());

  Future<void> _openForm([Note? note]) async {
    final result =
        await Navigator.of(context).pushNamed(AppRoutes.noteForm, arguments: note);
    if (result is String && mounted) {
      _reload();
      showAppSnack(context, result);
    }
  }

  Future<void> _delete(Note note) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete note?',
      message: '"${note.title}" will be removed permanently.',
    );
    if (!ok || !mounted) return;
    try {
      await DatabaseHelper.instance.deleteNote(note.id!);
      if (!mounted) return;
      _reload();
      showAppSnack(context, 'Note deleted');
    } catch (_) {
      if (mounted) showAppSnack(context, 'Could not delete the note', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'notes'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add note'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _searchController,
                    hint: 'Search notes',
                    onChanged: _reload,
                  ),
                ),
                PopupMenuButton<NoteSort>(
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
          Expanded(
            child: FutureBuilder<List<Note>>(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return DbErrorView(error: snapshot.error, onRetry: _reload);
                }
                final notes = snapshot.data ?? [];
                if (notes.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.trim().isEmpty
                          ? 'No notes yet. Tap "Add note" to create one.'
                          : 'No notes match your search.',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                  itemCount: notes.length,
                  itemBuilder: (context, i) => _NoteCard(
                    note: notes[i],
                    onTap: () => _openForm(notes[i]),
                    onDelete: () => _delete(notes[i]),
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

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.softYellow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark ? AppColors.darkText : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? AppColors.darkText : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${note.subject} • ${formatDate(note.createdDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                      ),
                    ),
                  ],
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
