/// A instance of an athlete
class Athlete {
  /// {@macro athlete}
  const Athlete({
    required this.id,
    required this.teamId,
    required this.fullName,
    required this.taxCode,
    this.birthdate,
    this.birthPlace,
    this.email,
    this.phone,
    this.fullAddress,
    this.nationality,
    this.archived,
    this.paymentFormulaId,
  });

  ///
  final String id;

  ///
  final String teamId;

  ///
  final String fullName;

  ///
  final String taxCode;

  ///
  final DateTime? birthdate;

  ///
  final String? birthPlace;

  ///
  final String? email;

  ///
  final String? phone;

  ///
  final String? fullAddress;

  ///
  final String? nationality;

  ///
  final bool? archived;

  ///
  final String? paymentFormulaId;


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
    String? paymentFormulaId,
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
      'payment_formula_id': paymentFormulaId
    };
  }

  static List<Athlete> fromList(List<Map<String, dynamic>> data) {
    return data.map(Athlete.fromMap).toList();
  }

  Athlete.fromMap(Map<String, dynamic> map)
    : teamId = map['team_id'] as String,
      id = map['id'] as String,
      fullName = map['full_name'] as String,
      taxCode = map['tax_code'] as String,
      birthdate = DateTime.tryParse(map['birth_date'] as String? ?? ''),
      birthPlace = map['birth_place'] as String?,
      email = map['email'] as String?,
      phone = map['phone'] as String?,
      fullAddress = map['full_address'] as String?,
      nationality = map['nationality'] as String?,
      archived = map['archived'] as bool?,
      paymentFormulaId = map['payment_formula_id'] as String?
  ;

  Athlete copyWith({
    String? id,
    String? teamId,
    String? fullName,
    String? taxCode,
    DateTime? birthDate,
    String? email,
    String? phone,
    String? fullAddress,
    bool? archived,
    String? paymentFormulaId,
  }) {
    return Athlete(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      fullName: fullName ?? this.fullName,
      taxCode: taxCode ?? this.taxCode,
      birthdate: birthDate ?? this.birthdate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullAddress: fullAddress ?? this.fullAddress,
      archived: archived ?? this.archived,
      paymentFormulaId: paymentFormulaId ?? this.paymentFormulaId
    );
  }
}