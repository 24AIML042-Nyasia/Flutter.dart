import 'package:flutter_test/flutter_test.dart';
import 'package:smart_student_companion/models/notice.dart';

void main() {
  test('Notice.fromJson maps the API fields', () {
    final json = {
      'id': 1,
      'title': 'Exam schedule',
      'body': 'Internal exams start next week.',
      'tags': ['history', 'crime'],
      'reactions': {'likes': 12, 'dislikes': 3},
      'views': 305,
      'userId': 5,
    };
    final notice = Notice.fromJson(json, organizer: 'Emily Johnson (Engineering)');
    expect(notice.title, 'Exam schedule');
    expect(notice.description, 'Internal exams start next week.');
    expect(notice.category, 'History');
    expect(notice.likes, 12);
    expect(notice.views, 305);
    expect(notice.organizer, 'Emily Johnson (Engineering)');
  });

  test('Notice.fromJson survives missing and old-style fields', () {
    final notice = Notice.fromJson({'id': 2, 'reactions': 7});
    expect(notice.title, 'Untitled notice');
    expect(notice.category, 'General');
    expect(notice.likes, 7);
    expect(notice.organizer, 'University Office');
  });
}
