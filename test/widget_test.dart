import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_student_companion/main.dart';
import 'package:smart_student_companion/services/prefs_service.dart';

void main() {
  testWidgets('Logged-out user is sent from Splash to Login',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await PrefsService.init();

    await tester.pumpWidget(const SmartStudentCompanionApp());
    expect(find.text('Smart Student Companion'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Saved session goes straight to the Dashboard',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'logged_in': true,
      'username': PrefsService.demoUsername,
    });
    await PrefsService.init();

    await tester.pumpWidget(const SmartStudentCompanionApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Course Dashboard'), findsOneWidget);
  });
}
