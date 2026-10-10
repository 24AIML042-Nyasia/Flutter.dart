import 'package:flutter/material.dart';
import '../models/student.dart';
import '../state/app_language.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

/// StatefulWidget that manages settings with setState().
///
/// EPHEMERAL STATE (lives only in this widget, setState rebuilds just this
/// screen): text fields, semester dropdown, notification checkboxes,
/// course checkboxes.
///
/// APPLICATION STATE (shared with other screens through ValueNotifiers):
/// the saved profile, dark mode, language, and dashboard customization.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ---- Ephemeral state: profile form ----
  late final TextEditingController _nameController;
  late final TextEditingController _enrollmentController;
  late final TextEditingController _departmentController;
  late int _selectedSemester;

  // ---- Ephemeral state: notification preferences (Checkbox) ----
  // Keys are translation ids (see app_language.dart).
  final Map<String, bool> _notificationPrefs = {
    'assignmentAlerts': true,
    'examNotifications': true,
    'placementUpdates': true,
    'eventAnnouncements': true,
  };

  // ---- Ephemeral state: course preferences (Checkbox) ----
  final Map<String, bool> _coursePrefs = {
    'courseMad': true,
    'courseAi': true,
    'courseDbms': false,
    'courseCn': false,
  };

  static const List<String> _romanNumerals = [
    'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII',
  ];

  @override
  void initState() {
    super.initState();
    final student = currentStudentNotifier.value;
    _nameController = TextEditingController(text: student.name);
    _enrollmentController = TextEditingController(text: student.enrollmentNo);
    _departmentController = TextEditingController(text: student.department);
    _selectedSemester = student.semester;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _enrollmentController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  /// Promotes the edited profile from Ephemeral to Application State by
  /// writing a new Student into the shared notifier.
  void _saveProfile() {
    final current = currentStudentNotifier.value;
    String pick(String typed, String fallback) =>
        typed.trim().isEmpty ? fallback : typed.trim();

    currentStudentNotifier.value = Student(
      name: pick(_nameController.text, current.name),
      email: current.email,
      enrollmentNo: pick(_enrollmentController.text, current.enrollmentNo),
      department: pick(_departmentController.text, current.department),
      semester: _selectedSemester,
      cgpa: current.cgpa,
      attendancePercentage: current.attendancePercentage,
      subjects: current.subjects,
      notifications: current.notifications,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(context, 'profileUpdated'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            title: tr(context, 'profileSettings'),
            color: AppColors.lavender,
            children: [
              CustomTextField(
                controller: _nameController,
                label: tr(context, 'fullName'),
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _enrollmentController,
                label: tr(context, 'enrollmentNo'),
                icon: Icons.numbers_outlined,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _departmentController,
                label: tr(context, 'department'),
                icon: Icons.apartment_outlined,
              ),
              const SizedBox(height: 12),
              _semesterDropdown(),
              const SizedBox(height: 16),
              CustomButton(
                label: tr(context, 'saveProfile'),
                onPressed: _saveProfile,
              ),
            ],
          ),
          _section(
            title: tr(context, 'themeSelection'),
            color: AppColors.babyBlue,
            children: [_themeSwitch()],
          ),
          _section(
            title: tr(context, 'languageSelection'),
            color: AppColors.mintGreen,
            children: [
              for (final lang in appLanguages) _languageRadio(lang),
            ],
          ),
          _section(
            title: tr(context, 'notificationPrefs'),
            color: AppColors.softYellow,
            children: [
              for (final key in _notificationPrefs.keys)
                _checkboxRow(
                  label: tr(context, key),
                  value: _notificationPrefs[key]!,
                  onChanged: (v) =>
                      setState(() => _notificationPrefs[key] = v ?? false),
                ),
            ],
          ),
          _section(
            title: tr(context, 'coursePrefs'),
            color: AppColors.peach,
            children: [
              for (final key in _coursePrefs.keys)
                _checkboxRow(
                  label: tr(context, key),
                  value: _coursePrefs[key]!,
                  onChanged: (v) =>
                      setState(() => _coursePrefs[key] = v ?? false),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  tr(context, 'selectedCount')
                      .replaceAll('{a}', '${_coursePrefs.values.where((v) => v).length}')
                      .replaceAll('{b}', '${_coursePrefs.length}'),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          _section(
            title: tr(context, 'dashboardCustomization'),
            color: AppColors.blushPink,
            children: [_dashboardSlider(), const SizedBox(height: 8), _moduleSwitches()],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  Widget _section({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// DropdownButton: Semester I - VIII.
  Widget _semesterDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<int>(
      value: _selectedSemester,
      decoration: InputDecoration(
        labelText: tr(context, 'semester'),
        labelStyle: TextStyle(
          color: isDark ? AppColors.darkTextMuted : AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.textDark,
        fontSize: 16,
      ),
      dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
      iconEnabledColor: isDark ? AppColors.darkText : AppColors.textDark,
      items: [
        for (var i = 0; i < _romanNumerals.length; i++)
          DropdownMenuItem<int>(
            value: i + 1,
            child: Text(
              '${tr(context, 'semester')} ${_romanNumerals[i]}',
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.textDark,
                fontSize: 16,
              ),
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) setState(() => _selectedSemester = value);
      },
    );
  }

  /// Switch: Light / Dark theme. Application State — the whole app reacts.
  Widget _themeSwitch() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          title: Text(
            tr(context, 'darkMode'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            tr(context, mode == ThemeMode.dark ? 'darkOn' : 'lightOn'),
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          value: mode == ThemeMode.dark,
          onChanged: (v) {
            themeModeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
          },
        );
      },
    );
  }

  /// Radio button: one language at a time. Application State — choosing
  /// a language re-translates the whole app instantly.
  Widget _languageRadio(String lang) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: AppColors.primary,
      title: Text(lang),
      value: lang,
      groupValue: languageNotifier.value,
      onChanged: (value) {
        if (value != null) languageNotifier.value = value;
      },
    );
  }

  /// Checkbox: many options can be on at once.
  Widget _checkboxRow({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: AppColors.primary,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  /// Slider: how many cards appear per row on the dashboard (1 to 3).
  /// Application State — the Dashboard redraws as the slider moves.
  Widget _dashboardSlider() {
    return ValueListenableBuilder<int>(
      valueListenable: dashboardColumnsNotifier,
      builder: (context, columns, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${tr(context, 'cardsPerRow')}: $columns',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: columns.toDouble(),
              min: 1,
              max: 3,
              divisions: 2,
              label: '$columns',
              activeColor: AppColors.primary,
              onChanged: (v) => dashboardColumnsNotifier.value = v.round(),
            ),
          ],
        );
      },
    );
  }

  /// Switches: show or hide each dashboard module. Settings itself can't
  /// be hidden, so it always stays reachable.
  Widget _moduleSwitches() {
    const ids = ['attendance', 'timetable', 'assignments', 'faculty', 'events'];
    return ValueListenableBuilder<Set<String>>(
      valueListenable: hiddenModulesNotifier,
      builder: (context, hidden, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(context, 'showModules'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            for (final id in ids)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                activeColor: AppColors.primary,
                title: Text(tr(context, id)),
                value: !hidden.contains(id),
                onChanged: (show) {
                  final updated = Set<String>.from(hidden);
                  show ? updated.remove(id) : updated.add(id);
                  hiddenModulesNotifier.value = updated;
                },
              ),
          ],
        );
      },
    );
  }
}
