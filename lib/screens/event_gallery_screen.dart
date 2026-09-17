import 'package:flutter/material.dart';
import '../theme.dart';

class EventItem {
  final String title;
  final IconData icon;
  final Color color;
  const EventItem(this.title, this.icon, this.color);
}

/// StatelessWidget: fixed sample events.
/// Demonstrates: GridView (a scrollable grid of cards) and LayoutBuilder
/// so the number of columns adapts to the available screen width — this
/// is what makes the gallery responsive across phone/tablet sizes.
/// Each card also uses a Stack to layer the title over a colored backdrop.
class EventGalleryScreen extends StatelessWidget {
  const EventGalleryScreen({super.key});

  static const List<EventItem> _events = [
    EventItem('Tech Fest 2026', Icons.celebration_rounded, AppColors.peach),
    EventItem('Coding Marathon', Icons.code_rounded, AppColors.mintGreen),
    EventItem('AI Workshop', Icons.smart_toy_rounded, AppColors.babyBlue),
    EventItem('Sports Meet', Icons.sports_soccer_rounded, AppColors.blushPink),
    EventItem('Cultural Night', Icons.music_note_rounded, AppColors.softYellow),
    EventItem('Guest Lecture', Icons.record_voice_over_rounded, AppColors.lavender),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Gallery')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive column count: more columns on wider screens.
            final width = constraints.maxWidth;
            final crossAxisCount = width < 500
                ? 2
                : width < 900
                    ? 3
                    : 4;

            return GridView.builder(
              itemCount: _events.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) => _EventCard(event: _events[index]),
            );
          },
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventItem event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: event.color),
          Positioned(
            top: 12,
            left: 12,
            child: Icon(event.icon, size: 28, color: AppColors.textDark),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Text(
              event.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
