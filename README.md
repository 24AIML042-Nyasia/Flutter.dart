# Smart Student Companion App

A Flutter app built as part of the Mobile Application Development practicals.

## Overview

A pastel-themed student utility app with light and dark mode support. It covers a splash screen, login, registration, a responsive dashboard, and screens for attendance, timetable, assignments, faculty info, event gallery, notifications, profile, and settings.

## Screens

- **Splash** — loading screen that navigates to Login
- **Login / Registration** — form validation with enrollment number and email
- **Dashboard** — responsive grid of module cards, adapts columns to screen width
- **Attendance** — overall ring + per-subject progress bars
- **Timetable** — weekly schedule by day
- **Assignments** — list of assignments with status and due dates
- **Faculty** — faculty info tiles
- **Event Gallery** — responsive grid of event cards
- **Notifications** — notification feed
- **Profile** — student details
- **Settings** — profile editing, dark/light theme toggle, language selection, notification and course preferences, dashboard customization

## Key widgets

- `CustomTextField` — styled form field used across login, registration, and settings
- `ProfileCard` — compact on dashboard, full detail on profile screen
- `DashboardCard` — reusable pastel module card
- `CustomButton` — reusable pastel button

## Running it

```bash
flutter create . --project-name smart_student_companion
flutter pub get
flutter run
```

> `flutter create .` only generates the missing platform folders and will not overwrite existing `lib/` or `pubspec.yaml` files.
