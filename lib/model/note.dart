class Note {
  Note({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String author;
  final String content;
  final DateTime createdAt;

  static Map<String, dynamic> create({
    required String author,
    required String content,
  }) {
    return {
      'author': author,
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static List<Note> fromList(List<Map<String, dynamic>> data) {
    return data.map(Note.fromMap).toList();
  }

  Note.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        author = map['author'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']);

  Note copyWith({
    String? id,
    String? ownerId,
    String? author,
    String? content,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
