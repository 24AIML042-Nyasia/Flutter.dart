import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/prefs_service.dart';
import '../state/app_language.dart';

/// Asks for confirmation, then logs out: clears everything stored in
/// Shared Preferences and returns to Login with an empty navigation stack
/// (so Back can't return to the dashboard).
Future<void> confirmAndLogout(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(tr(context, 'logout')),
      content: Text(tr(context, 'confirmLogout')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(tr(context, 'cancel')),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            tr(context, 'logout'),
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;
  await PrefsService.logout();
  if (!context.mounted) return;
  Navigator.of(context).pushNamedAndRemoveUntil(
    AppRoutes.login,
    (route) => false,
  );
}
