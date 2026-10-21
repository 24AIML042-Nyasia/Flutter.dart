import 'package:flutter/material.dart';
import '../theme.dart';

/// Shown by a FutureBuilder when reading the database fails.
class DbErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;

  const DbErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final message = error is UnsupportedError
        ? (error as UnsupportedError).message ?? 'Not supported on this platform.'
        : 'Something went wrong while reading the database.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
