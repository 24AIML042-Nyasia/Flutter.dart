/// One academic notice, built from a JSON post returned by the REST API.
///
/// JSON from https://dummyjson.com/posts (one item of the "posts" list):
/// {
///   "id": 1,
///   "title": "...",
///   "body": "...",
///   "tags": ["history", "crime"],
///   "reactions": {"likes": 192, "dislikes": 25},
///   "views": 305,
///   "userId": 121
/// }
/// The API has no date, organizer or image, so those are filled in as
/// described on the matching fields below.
class Notice {
  final int id;
  final String title;
  final String description; // JSON "body"
  final String category; // first JSON tag, capitalised
  final String organizer; // looked up from the users API with "userId"
  final DateTime date; // not in the API: derived from the id
  final String imageUrl; // not in the API: placeholder photo seeded by id
  final int views;
  final int likes;

  const Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.organizer,
    required this.date,
    required this.imageUrl,
    required this.views,
    required this.likes,
  });

  /// Converts one JSON object into a Notice. Missing fields get safe
  /// defaults so one odd record cannot crash the whole list.
  factory Notice.fromJson(
    Map<String, dynamic> json, {
    String organizer = 'University Office',
    DateTime? today,
  }) {
    final id = (json['id'] as num?)?.toInt() ?? 0;

    final tags = (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [];
    final category = tags.isEmpty ? 'General' : _capitalise(tags.first);

    // "reactions" is an object in current API versions and a number in old ones.
    final reactions = json['reactions'];
    final likes = reactions is Map
        ? (reactions['likes'] as num?)?.toInt() ?? 0
        : (reactions is num ? reactions.toInt() : 0);

    final now = today ?? DateTime.now();
    final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: id % 30));

    return Notice(
      id: id,
      title: json['title']?.toString() ?? 'Untitled notice',
      description: json['body']?.toString() ?? '',
      category: category,
      organizer: organizer,
      date: date,
      imageUrl: 'https://picsum.photos/seed/notice$id/600/320',
      views: (json['views'] as num?)?.toInt() ?? 0,
      likes: likes,
    );
  }

  static String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
