import 'package:flutter/material.dart';
import '../theme.dart';

/// StatefulWidget: switches need to hold and update their own boolean
/// state via setState.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ValueListenableBuilder<ThemeMode>(
        // Rebuilds this screen whenever the app-wide theme mode changes,
        // so the switch always reflects the real current mode.
        valueListenable: themeModeNotifier,
        builder: (context, mode, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _settingSwitch(
                context: context,
                title: 'Push notifications',
                subtitle: 'Assignments, events and attendance alerts',
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              _settingSwitch(
                context: context,
                title: 'Email updates',
                subtitle: 'Weekly summary sent to your inbox',
                value: _emailUpdates,
                onChanged: (v) => setState(() => _emailUpdates = v),
              ),
              _settingSwitch(
                context: context,
                title: 'Dark mode',
                subtitle: 'Switch the whole app to a dark theme',
                value: mode == ThemeMode.dark,
                onChanged: (v) {
                  themeModeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _settingSwitch({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.babyBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeColor: AppColors.primary,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
