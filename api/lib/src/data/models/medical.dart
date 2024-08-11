enum MedType {
  agonistic,
  not_agonistic,
  not_required;

  String get name {
    switch (this) {
      case MedType.agonistic:
        return 'Agonistic';
      case MedType.not_agonistic:
        return 'Not agonistic';
      case MedType.not_required:
        return 'Not required';
    }
  }
}

/// The available medical visit types
enum MedStatus {
  /// An expired medical visit
  expired,

  /// An medical visit near expiration
  expireSoon,

  /// An valid medical visit
  good,

  /// An unknown medical visit
  unknown
}

class Medical {
  Medical({
    required this.athleteId,
    required this.fullName,
    required this.type,
    required this.expire,
  });

  final String athleteId;

  /// Athlete full name
  final String fullName;

  final MedType? type;

  final DateTime? expire;

  static Map<String, dynamic> create({
    required String athleteId,
    MedType? type,
    DateTime? expirationDate,
  }) {
    return {
      'athlete_id': athleteId,
      'type': type?.name,
      'expire': expirationDate?.toIso8601String(),
    };
  }

  static List<Medical> fromList(List<Map<String, dynamic>> data) {
    return data.map(Medical.fromMap).toList();
  }

  factory Medical.fromMap(Map<String, dynamic> map) {
    return Medical(
      athleteId: map['athlete_id'] as String,
      fullName: map['athletes']['full_name'] as String,
      type: map['type'] == 'not_required'
          ? MedType.not_required
          : map['type'] == 'not_agonistic'
              ? MedType.not_agonistic
              : MedType.agonistic,
      expire: map['expire'] != null
          ? DateTime.tryParse(map['expire'] as String)
          : null,
    );
  }

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
      expire: expirationDate ?? this.expire,
    );
  }
}
