import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../state/app_language.dart';
import '../theme.dart';
import '../utils/date_utils.dart';

/// Academic notices loaded live from a REST API.
///  - FutureBuilder shows a loading indicator, an error with Retry, or the list.
///  - Pull down to refresh re-calls the API.
class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final ApiService _api = ApiService();
  late Future<List<Notice>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchNotices();
  }

  /// Retry button: start a fresh request and show the loading indicator.
  void _retry() => setState(() => _future = _api.fetchNotices());

  /// Pull-to-refresh: the indicator stays until the new data (or error) arrives.
  Future<void> _refresh() async {
    final fresh = _api.fetchNotices();
    setState(() => _future = fresh);
    try {
      await fresh;
    } catch (_) {
      // The error is shown by the FutureBuilder below.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'notices')),
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            tooltip: tr(context, 'feedback'),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.feedback),
          ),
        ],
      ),
      body: FutureBuilder<List<Notice>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorView(error: snapshot.error, onRetry: _retry);
          }
          final notices = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _refresh,
            child: notices.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 160),
                      Center(
                        child: Text(
                          'No notices available.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: notices.length,
                    itemBuilder: (context, i) => _NoticeCard(notice: notices[i]),
                  ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final message = error is ApiException
        ? (error as ApiException).message
        : 'Something went wrong while loading notices.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.textDark;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image (if it cannot load, a pastel placeholder is shown instead)
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.network(
              notice.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(
                      color: AppColors.lavender,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
              errorBuilder: (context, error, stack) => Container(
                color: AppColors.lavender,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: AppColors.textMuted),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.mintGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        notice.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.event_rounded, size: 14, color: mutedColor),
                    const SizedBox(width: 4),
                    Text(
                      formatDate(dateToIso(notice.date)),
                      style: TextStyle(fontSize: 12, color: mutedColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  notice.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notice.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 16, color: mutedColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        notice.organizer,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: mutedColor),
                      ),
                    ),
                    Icon(Icons.thumb_up_alt_outlined, size: 14, color: mutedColor),
                    const SizedBox(width: 4),
                    Text('${notice.likes}',
                        style: TextStyle(fontSize: 12, color: mutedColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
