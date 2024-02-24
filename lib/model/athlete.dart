class Athlete {
  final String id;
  final String teamId;
  final String fullName;
  final String taxCode;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? email;
  final String? phone;
  final String? fullAddress;
  final String? nationality;
  final bool? archived;

  Athlete({
    required this.id,
    required this.teamId,
    required this.fullName,
    required this.taxCode,
    this.birthDate,
    this.birthPlace,
    this.email,
    this.phone,
    this.fullAddress,
    this.nationality,
    this.archived,
  });

  static Map<String, dynamic> create({
    required String teamId,
    required String fullName,
    required String taxCode,
    DateTime? birthDate,
    String? birthPlace,
    String? email,
    String? phone,
    String? fullAddress,
    String? nationality,
    bool? archived,
  }) {
    return {
      'full_name': fullName,
      'tax_code': taxCode,
      'team_id': teamId,
      'birth_date': birthDate,
      'birth_place': birthPlace,
      'email': email,
      'phone': phone,
      'full_address': fullAddress,
      'nationality': nationality,
      'archived': archived ?? false,
    };
  }

  static List<Athlete> fromList(List<Map<String, dynamic>> data) {
    return data.map(Athlete.fromMap).toList();
  }

  Athlete.fromMap(Map<String, dynamic> map)
    : teamId = map['team_id'],
      id = map['id'],
      fullName = map['full_name'],
      taxCode = map['tax_code'],
      birthDate = DateTime.parse(map['birth_date']),
      birthPlace = map['birth_place'],
      email = map['email'],
      phone = map['phone'],
      fullAddress = map['full_address'],
      nationality = map['nationality'],
      archived = map['archived']
  ;

  Athlete copyWith({
    String? id,
    String? ownerId,
    String? teamId,
    String? fullName,
    String? taxCode,
    DateTime? birthDate,
    String? email,
    String? phone,
    String? fullAddress,
    bool? archived,
    DateTime? createdAt,
  }) {
    return Athlete(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      fullName: fullName ?? this.fullName,
      taxCode: taxCode ?? this.taxCode,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullAddress: fullAddress ?? this.fullAddress,
      archived: archived ?? this.archived,
    );
  }
}