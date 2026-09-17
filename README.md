# Smart Student Companion App — Practical 1

Flutter environment setup + Dart fundamentals demo for the Smart Student
Companion App.

## What's inside

- `lib/main.dart` — app entry point, pastel Material theme
- `lib/theme.dart` — pastel color palette & ThemeData
- `lib/models/student.dart` — `Person` base class and `Student` subclass
  demonstrating constructors, encapsulation, and inheritance, plus a
  `DartConceptsDemo` helper for variables/operators/functions
- `lib/screens/home_screen.dart` — dashboard (profile, attendance, courses,
  assignments, notifications, events)
- `lib/screens/dart_concepts_screen.dart` — on-screen demo of variables, data
  types, operators, conditionals, loops, and OOP concepts
- `lib/widgets/dashboard_card.dart` — reusable pastel card widget

## Running it

This repo contains only the `lib/`, `test/`, `pubspec.yaml` and config files
(no generated `android/`/`ios/` folders, since those are machine-specific and
get created automatically). To run it:

```bash
flutter create . --project-name smart_student_companion   # generates android/ios/etc. in place
flutter pub get
flutter doctor                                             # verify your setup
flutter run                                                 # run on emulator/device
```

> Running `flutter create .` inside this folder will not overwrite the
> existing `lib/`, `pubspec.yaml`, or `test/` files — it only fills in the
> missing platform folders.

## Concepts demonstrated

Variables & constants, data types, operators, conditional statements, loops,
functions, classes, constructors, inheritance, and encapsulation — all
visible live in the app under the "Dart Concepts" card on the dashboard.
