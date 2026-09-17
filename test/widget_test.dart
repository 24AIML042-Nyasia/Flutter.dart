import 'package:flutter_test/flutter_test.dart';

import 'package:smart_student_companion/main.dart';

void main() {
  testWidgets('Home screen shows app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartStudentCompanionApp());

    expect(find.text('Smart Student Companion'), findsOneWidget);
  });
}
