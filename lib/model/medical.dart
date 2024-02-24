enum MedType{
  agonistic,
  not_agonistic,
  not_required
}

class Medical {
  Medical({
    required this.athleteId,
    required this.fullName,
    required this.type,
    required this.expirationDate,
  });

  final String athleteId;
  /// Athlete full name
  final String fullName;
  final MedType type;
  final DateTime? expirationDate;

  static Map<String, dynamic> create({
    required String athleteId,
    required MedType type,
    required DateTime expirationDate,
  }) {
    return {
      'athlete_id': athleteId,
      'type': type,
      'expire': expirationDate,
    };
  }

  static List<Medical> fromList(List<Map<String, dynamic>> data) {
    return data.map(Medical.fromMap).toList();
  }

  Medical.fromMap(Map<String, dynamic> map)
      : athleteId = map['athlete_id'],
        fullName = map['full_name'],
        type = map['type'],
        expirationDate = DateTime.parse(map['expire'])
  ;

  Medical copyWith({
    String? athleteId,
    String? fullName,
    MedType? type,
    DateTime? expirationDate,
  }) {
    return Medical(
      athleteId: athleteId ?? this.athleteId,
      fullName: fullName ?? this.fullName,
      type: type ?? this.type,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}
