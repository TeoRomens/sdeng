class Parent {
  final String id;
  final String athleteId;
  final String fullName;
  final String taxCode;
  final String? email;
  final String? phone;
  final String? fullAddress;

  Parent({
    required this.id,
    required this.athleteId,
    required this.fullName,
    required this.taxCode,
    this.email,
    this.phone,
    this.fullAddress,
  });

  static Map<String, dynamic> create({
    required String athleteId,
    required String fullName,
    required String taxCode,
    String? email,
    String? phone,
    String? fullAddress,
  }) {
    return {
      'athlete_id': athleteId,
      'full_name': fullName,
      'tax_code': taxCode,
      'email': email,
      'phone': phone,
      'full_address': fullAddress,
    };
  }

  static List<Parent> fromList(List<Map<String, dynamic>> data) {
    return data.map(Parent.fromMap).toList();
  }

  Parent.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        athleteId = map['athlete_id'],
        fullName = map['full_name'],
        taxCode = map['tax_code'],
        email = map['email'],
        phone = map['phone'],
        fullAddress = map['full_address']
  ;

  Parent copyWith({
    String? id,
    String? athleteId,
    String? fullName,
    String? taxCode,
    String? email,
    String? phone,
    String? fullAddress,
    DateTime? createdAt,
  }) {
    return Parent(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      fullName: fullName ?? this.fullName,
      taxCode: taxCode ?? this.taxCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }
}