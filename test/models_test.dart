import 'package:flutter_test/flutter_test.dart';
import 'package:smart_student_companion/models/note.dart';
import 'package:smart_student_companion/models/task.dart';

void main() {
  test('Note survives a toMap / fromMap round trip', () {
    const note = Note(
      id: 1,
      title: 'Flutter Widgets',
      description: 'Study Stateless and Stateful Widgets.',
      subject: 'Mobile Application Development',
      createdDate: '2026-10-10',
    );
    final copy = Note.fromMap(note.toMap());
    expect(copy.id, 1);
    expect(copy.title, 'Flutter Widgets');
    expect(copy.subject, 'Mobile Application Development');
    expect(copy.createdDate, '2026-10-10');
  });

  test('Task omits id until inserted and tracks completion', () {
    const task = Task(
      name: 'Submit Flutter Assignment',
      dueDate: '2026-10-12',
      priority: 'High',
      status: Task.pending,
    );
    expect(task.toMap().containsKey('id'), isFalse);
    expect(task.isCompleted, isFalse);
    expect(task.copyWith(status: Task.completed).isCompleted, isTrue);
  });
}
