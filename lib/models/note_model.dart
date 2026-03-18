class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // من Firestore لـ Dart Object
  factory NoteModel.fromFirestore(Map<String, dynamic> json, String id) {
    return NoteModel(
      id: id,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // من Dart Object لـ Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
