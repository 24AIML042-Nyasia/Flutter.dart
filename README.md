# Smart Student Companion App

A Flutter app for the Smart Student Companion project — pastel UI covering
splash, login, registration, a responsive dashboard, attendance, timetable,
assignments, faculty info, an event gallery, notifications, and settings.

## What's inside

- `lib/theme.dart` — pastel color palette, light + dark `ThemeData`, and the
  global `themeModeNotifier` that switches the app's theme
- `lib/models/student.dart` — `Person` base class and `Student` subclass
  demonstrating constructors, encapsulation, and inheritance
- `lib/main.dart` — loads saved preferences, then starts the app with
  named routes (`initialRoute` + `onGenerateRoute`)
- `lib/routes/app_routes.dart` — route name constants
- `lib/routes/app_router.dart` — route table and the animated slide/fade
  page transition
- `lib/services/prefs_service.dart` — **Shared Preferences**: login status,
  username, theme, language, semester/profile, notification settings and
  dashboard customization are saved and restored; logout clears everything
- `lib/screens/splash_screen.dart` — checks the saved session: logged in goes
  to the Dashboard, otherwise to Login
- `lib/screens/login_screen.dart` — form validation, checks the credentials,
  saves the session
- `lib/screens/registration_screen.dart` — registration form (UI only)
- `lib/screens/home_screen.dart` — main shell: **Drawer** + **Bottom
  Navigation Bar** (Dashboard, Attendance, Timetable, Profile)
- `lib/screens/dashboard_tab.dart` — the module cards; each opens a named route
- `lib/services/database_helper.dart` — **SQLite (sqflite)**: creates the
  `notes` and `tasks` tables, seeds the sample records, and provides async
  CRUD, search, sort and filter queries
- `lib/models/note.dart`, `lib/models/task.dart` — table row classes
  (`toMap` / `fromMap`)
- `lib/screens/notes_screen.dart` / `note_form_screen.dart` — Student Notes:
  `FutureBuilder` list, search, sort, add / edit / delete with confirmation
- `lib/screens/tasks_screen.dart` / `task_form_screen.dart` — Task Manager:
  search, sort, status filter, completion checkbox, add / edit / delete
- `lib/services/api_service.dart` — **REST API (http package)**: GET notices
  and organizers, POST feedback; checks connectivity, applies a timeout and
  turns every failure into a readable `ApiException`
- `lib/models/notice.dart` — JSON to Dart model (`Notice.fromJson`)
- `lib/screens/notices_screen.dart` — `FutureBuilder` list with loading
  indicator, error + Retry, and pull-to-refresh
- `lib/screens/feedback_screen.dart` — validated form sent with HTTP POST
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
  details and the Log out button
- `lib/screens/settings_screen.dart` — **StatefulWidget** using `setState()`;
  profile editing (TextFields + Semester `DropdownButton`), Dark mode
  `Switch`, Language `Radio` buttons (live English/Hindi/Gujarati
  translation), Notification and Course `Checkbox`es, and Dashboard
  Customization (cards-per-row `Slider` + module show/hide `Switch`es)
- `lib/state/app_state.dart` — Application State shared across screens
  (student profile, dashboard columns, hidden modules) via `ValueNotifier`s
- `lib/state/app_language.dart` — selected language + `tr()` translations;
  `LanguageScope` in `main.dart` re-translates every screen instantly
- `lib/widgets/dashboard_card.dart` — reusable pastel dashboard card
- `lib/widgets/profile_card.dart` — reusable profile card (compact on the
  dashboard, full detail on the Profile screen)
- `lib/widgets/notification_tile.dart` — reusable notification row
- `lib/widgets/custom_text_field.dart` — reusable styled `TextFormField`
- `lib/widgets/custom_button.dart` — reusable pastel button

App flow: `/` (Splash) -> saved session? `/home` : `/login` -> `/home`
(Drawer + Bottom Navigation) -> `/attendance`, `/timetable`, `/assignments`,
`/events`, `/faculty`, `/notifications`, `/settings`, `/profile`.
Logout clears Shared Preferences and returns to `/login` with an empty back stack.

Demo login: `rahul.patel@charusat.edu.in` / `student@123`

## Navigation and storage notes

- **Named routes** are declared once in `app_router.dart` and opened with
  `Navigator.pushNamed`; `pushReplacementNamed` (Splash/Login) and
  `pushNamedAndRemoveUntil` (logout) stop Back from returning to old screens.
- **Shared Preferences** stores simple key-value data (bool, int, String,
  list of String). It is not encrypted, so it suits preferences and a login
  flag, not real passwords (use secure storage) or large relational data
  (use SQLite).

## State management notes

- **Ephemeral State** (private to one widget, updated with `setState()`):
  text fields, semester dropdown, language radio buttons, notification and
  course checkboxes on the Settings screen.
- **Application State** (shared by several screens): the saved student
  profile, dark mode (`themeModeNotifier` in `theme.dart`), the selected
  language, and the dashboard customization (columns + visible modules). Changing them on Settings updates the
  Dashboard immediately, with no restart.

## Database notes (Practical 6)

Tables:

| notes | type | | tasks | type |
|---|---|---|---|---|
| id | INTEGER PK AUTOINCREMENT | | id | INTEGER PK AUTOINCREMENT |
| title | TEXT NOT NULL | | name | TEXT NOT NULL |
| description | TEXT NOT NULL | | due_date | TEXT NOT NULL (YYYY-MM-DD) |
| subject | TEXT NOT NULL | | priority | TEXT NOT NULL (High/Medium/Low) |
| created_date | TEXT NOT NULL (YYYY-MM-DD) | | status | TEXT NOT NULL (Pending/Completed) |

- Every database call is `async` and returns a `Future`; the list screens
  hold that Future and show it with a `FutureBuilder` (spinner, error,
  empty message, or the list).
- Search uses `LIKE` with `?` placeholders; sort order comes from a fixed
  map, never from user text.
- The database file is stored with the **Path Provider** package (app
  documents folder). SQLite is set up for Android and iOS (standard `sqflite`)
  and for Chrome/Edge (`sqflite_common_ffi_web`; run
  `dart run sqflite_common_ffi_web:setup` once to create `sqlite3.wasm` and
  `sqflite_sw.js` in `web/`). The Windows desktop target is not supported.

## REST API notes (Practical 7)

Base URL: `https://dummyjson.com` (no API key needed).

| Method | Endpoint | Used for |
|---|---|---|
| GET | `/posts?limit=20` | Notices (title, body, tags, reactions, views, userId) |
| GET | `/users?limit=0&select=id,firstName,lastName,company` | Organizer name and department |
| POST | `/posts/add` | Feedback (the API simulates saving and returns the new id) |

`/posts` returns `{"posts": [ {id, title, body, tags[], reactions{likes, dislikes}, views, userId} ], "total", "skip", "limit"}`.
The API has no date, organizer or image, so the app takes the category from the
first tag, the organizer from the users API (`userId`), a date derived from the
id, and a placeholder photo from `picsum.photos`.

Error handling: offline check (`connectivity_plus`), 15 second timeout, HTTP
status check, JSON format check, a Retry button, and pull-to-refresh.
The Android manifest includes the `INTERNET` permission.

## Responsive layout notes

Both the dashboard grid (`home_screen.dart`) and the Event Gallery
(`event_gallery_screen.dart`) use `LayoutBuilder` to read the available
width and pick a column count — 2 columns on a typical phone, more on a
wider screen or tablet — so the UI adapts automatically instead of using a
fixed layout.

## Running it

```bash
flutter pub get
flutter run
```
