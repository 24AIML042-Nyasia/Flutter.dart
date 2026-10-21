/// One row of the `tasks` table.
class Task {
  static const List<String> priorities = ['High', 'Medium', 'Low'];
  static const String pending = 'Pending';
  static const String completed = 'Completed';

  final int? id;
  final String name;
  final String dueDate; // 'YYYY-MM-DD'
  final String priority; // High / Medium / Low
  final String status; // Pending / Completed

  const Task({
    this.id,
    required this.name,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  bool get isCompleted => status == completed;

  Task copyWith({String? status}) => Task(
        id: id,
        name: name,
        dueDate: dueDate,
        priority: priority,
        status: status ?? this.status,
      );

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'due_date': dueDate,
        'priority': priority,
        'status': status,
      };

  factory Task.fromMap(Map<String, Object?> map) => Task(
        id: map['id'] as int?,
        name: map['name'] as String,
        dueDate: map['due_date'] as String,
        priority: map['priority'] as String,
        status: map['status'] as String,
      );
}
