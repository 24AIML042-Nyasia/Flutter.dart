import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';
import '../models/task.dart';
import '../utils/date_utils.dart';

enum NoteSort { newest, oldest, titleAZ, subject }

enum TaskSort { dueDate, priority, name }

enum TaskFilter { all, pending, completed }

/// All SQLite work lives here. Every method is async (returns a Future) so
/// the UI never freezes while the database is read or written.
///
/// Schema
///   notes(id PK AUTOINCREMENT, title, description, subject, created_date)
///   tasks(id PK AUTOINCREMENT, name, due_date, priority, status)
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'student_companion.db';
  static const _dbVersion = 1;

  Database? _db;

  /// Opens the database the first time it is needed, then reuses it.
  Future<Database> get database async {
    // sqflite runs on Android / iOS, and in a browser through the web
    // factory set up in main.dart. Other targets (e.g. Windows) are not set up.
    final supported = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (!supported) {
      throw UnsupportedError(
        'SQLite is set up for Android, iOS and Chrome/Edge. '
        'Run the app on an Android emulator or device.',
      );
    }
    return _db ??= await _open();
  }

  /// Uses Path Provider to find the app's private documents folder and
  /// stores the database file there. (A browser has no folders; the web
  /// factory keeps the database in the browser's own storage.)
  Future<String> _databasePath() async {
    if (kIsWeb) return _dbName;
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _dbName);
  }

  Future<Database> _open() async {
    final path = await _databasePath();
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  /// Runs only once, when the database file is first created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        subject TEXT NOT NULL,
        created_date TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        due_date TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
    await _seed(db);
  }

  /// Sample records from the practical's dataset.
  Future<void> _seed(Database db) async {
    final today = DateTime.now();
    String inDays(int n) => dateToIso(today.add(Duration(days: n)));

    await db.insert(
      'notes',
      Note(
        title: 'Flutter Widgets',
        description: 'Study Stateless and Stateful Widgets.',
        subject: 'Mobile Application Development',
        createdDate: dateToIso(today),
      ).toMap(),
    );

    final tasks = [
      Task(name: 'Submit Flutter Assignment', dueDate: inDays(2), priority: 'High', status: Task.pending),
      Task(name: 'Prepare DBMS Practical', dueDate: inDays(4), priority: 'Medium', status: Task.pending),
      Task(name: 'Complete REST API Module', dueDate: inDays(7), priority: 'Medium', status: Task.pending),
      Task(name: 'Attend Placement Workshop', dueDate: inDays(10), priority: 'Low', status: Task.pending),
    ];
    for (final t in tasks) {
      await db.insert('tasks', t.toMap());
    }
  }

  // ------------------------------------------------------------------
  // Notes: Create / Read / Update / Delete (+ search and sort)
  // ------------------------------------------------------------------

  // ORDER BY text comes from this fixed map, never from user input.
  static const Map<NoteSort, String> _noteOrder = {
    NoteSort.newest: 'created_date DESC, id DESC',
    NoteSort.oldest: 'created_date ASC, id ASC',
    NoteSort.titleAZ: 'title COLLATE NOCASE ASC',
    NoteSort.subject: 'subject COLLATE NOCASE ASC, title COLLATE NOCASE ASC',
  };

  Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes({
    String search = '',
    NoteSort sort = NoteSort.newest,
  }) async {
    final db = await database;
    final term = search.trim();
    final rows = await db.query(
      'notes',
      // '?' placeholders keep the search text out of the SQL itself.
      where: term.isEmpty
          ? null
          : 'title LIKE ? OR description LIKE ? OR subject LIKE ?',
      whereArgs: term.isEmpty ? null : ['%$term%', '%$term%', '%$term%'],
      orderBy: _noteOrder[sort],
    );
    return rows.map(Note.fromMap).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------------------------------------------------------
  // Tasks: Create / Read / Update / Delete (+ search, sort, filter)
  // ------------------------------------------------------------------

  static const Map<TaskSort, String> _taskOrder = {
    TaskSort.dueDate: 'due_date ASC, id ASC',
    TaskSort.priority:
        "CASE priority WHEN 'High' THEN 0 WHEN 'Medium' THEN 1 ELSE 2 END, due_date ASC",
    TaskSort.name: 'name COLLATE NOCASE ASC',
  };

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks({
    String search = '',
    TaskSort sort = TaskSort.dueDate,
    TaskFilter filter = TaskFilter.all,
  }) async {
    final db = await database;
    final term = search.trim();

    final conditions = <String>[];
    final args = <Object?>[];
    if (term.isNotEmpty) {
      conditions.add('name LIKE ?');
      args.add('%$term%');
    }
    if (filter != TaskFilter.all) {
      conditions.add('status = ?');
      args.add(filter == TaskFilter.pending ? Task.pending : Task.completed);
    }

    final rows = await db.query(
      'tasks',
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: _taskOrder[sort],
    );
    return rows.map(Task.fromMap).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
