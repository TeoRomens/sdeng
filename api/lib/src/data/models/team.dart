/// A instance of a team
class Team {
  /// {@macro team}
  Team({
    required this.id,
    required this.name,
    this.numAthletes = 0,
  });

  ///
  Team.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        numAthletes = 0;

  final String id;
  final String name;
  final int numAthletes;

  ///
  static Map<String, dynamic> create({required String name}) {
    return {
      'name': name,
    };
  }

  ///
  static List<Team> fromList(List<Map<String, dynamic>> data) {
    return data.map(Team.fromMap).toList();
  }

  ///
  Team copyWith({
    String? id,
    String? name,
    int? numAthletes,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      numAthletes: numAthletes ?? this.numAthletes,
    );
  }
}
