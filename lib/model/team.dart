class Team {
  final String id;
  final String name;

  Team({
    required this.id,
    required this.name,
  });

  static Map<String, dynamic> create({
    required String name
  }) {
    return {
      'name': name,
    };
  }

  static List<Team> fromList(List<Map<String, dynamic>> data) {
    return data.map((row) => Team.fromMap(row)).toList();
  }

  Team.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name']
  ;

  Team copyWith({
    String? id,
    String? name,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
