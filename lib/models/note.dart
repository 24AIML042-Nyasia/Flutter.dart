/// One row of the `notes` table.
class Note {
  static const List<String> subjects = [
    'Mobile Application Development',
    'Database Management System',
    'Artificial Intelligence',
    'Computer Networks',
    'Other',
  ];

  final int? id; // null until the row has been inserted
  final String title;
  final String description;
  final String subject;
  final String createdDate; // 'YYYY-MM-DD'

  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.createdDate,
  });

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'subject': subject,
        'created_date': createdDate,
      };

  factory Note.fromMap(Map<String, Object?> map) => Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String,
        subject: map['subject'] as String,
        createdDate: map['created_date'] as String,
      );
}
