class Document {
  Document({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;

  static Map<String, dynamic> create({
    required String name,
  }) {
    return {
      'name': name,
    };
  }

  Document copyWith({
    String? name,
    String? path,
    DateTime? createdAt,
  }) {
    return Document(
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }
}
