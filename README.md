# Smart Student Companion App

A Flutter app for the Smart Student Companion project — pastel UI covering
splash, login, registration, a responsive dashboard, attendance, timetable,
assignments, faculty info, an event gallery, notifications, and settings.

## What's inside

- `lib/theme.dart` — pastel color palette, light + dark `ThemeData`, and the
  global `themeModeNotifier` that switches the app's theme
- `lib/models/student.dart` — `Person` base class and `Student` subclass
  demonstrating constructors, encapsulation, and inheritance
- `lib/screens/splash_screen.dart` — **StatefulWidget**; shows a loading
  state for 2 seconds, then navigates to Login
- `lib/screens/login_screen.dart` — **StatefulWidget**; `Form` +
  `TextFormField` validation, links to Registration
- `lib/screens/registration_screen.dart` — **StatefulWidget**; multi-field
  form with name/enrollment/department/email/password validation
- `lib/screens/home_screen.dart` — **StatelessWidget**; the Course Dashboard.
  Uses `LayoutBuilder` + `GridView` so the module grid adds columns
  automatically on wider screens, plus a notification bell + unread badge
  in the app bar
- `lib/screens/attendance_screen.dart` — **StatelessWidget**; overall
  attendance ring built with `Stack`, per-subject bars built with
  `Row` + `Expanded`
- `lib/screens/timetable_screen.dart` — **StatelessWidget**; weekly schedule
  using `ListView` of day cards, each a `Column` of `Row`-based time slots
- `lib/screens/assignment_list_screen.dart` — **StatelessWidget**;
  `ListView` of assignment tiles (`Row` + `Column` + `Expanded`)
- `lib/screens/faculty_screen.dart` — **StatelessWidget**; `ListView` of
  faculty info tiles
- `lib/screens/event_gallery_screen.dart` — **StatelessWidget**; responsive
  `GridView` (via `LayoutBuilder`) of at least six event cards, each built
  with a `Stack`
- `lib/screens/notifications_screen.dart` — **StatelessWidget**; notifications
  only, no student info
- `lib/screens/profile_screen.dart` — **StatelessWidget**; student profile
  details only
- `lib/screens/settings_screen.dart` — **StatefulWidget**; toggle switches,
  including a working Dark mode switch
- `lib/widgets/dashboard_card.dart` — reusable pastel dashboard card
- `lib/widgets/profile_card.dart` — reusable profile card (compact on the
  dashboard, full detail on the Profile screen)
- `lib/widgets/notification_tile.dart` — reusable notification row
- `lib/widgets/custom_text_field.dart` — reusable styled `TextFormField`
- `lib/widgets/custom_button.dart` — reusable pastel button

App flow: `SplashScreen` → `LoginScreen` → (`RegistrationScreen` optional) →
`HomeScreen` (Course Dashboard) → Attendance / Timetable / Assignments /
Faculty / Event Gallery / Notifications / Settings.

## Responsive layout notes

Both the dashboard grid (`home_screen.dart`) and the Event Gallery
(`event_gallery_screen.dart`) use `LayoutBuilder` to read the available
width and pick a column count — 2 columns on a typical phone, more on a
wider screen or tablet — so the UI adapts automatically instead of using a
fixed layout.

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
