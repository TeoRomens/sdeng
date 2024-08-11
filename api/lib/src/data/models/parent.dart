class Parent {
  Parent({
    required this.athleteId,
    this.fullName,
    this.taxCode,
    this.email,
    this.phone,
    this.fullAddress,
  });

  Parent.fromMap(Map<String, dynamic> map)
      : athleteId = map['athlete_id'] as String,
        fullName = map['full_name'] as String?,
        taxCode = map['tax_code'] as String?,
        email = map['email'] as String?,
        phone = map['phone'] as String?,
        fullAddress = map['full_address'] as String?;

  final String athleteId;
  final String? fullName;
  final String? taxCode;
  final String? email;
  final String? phone;
  final String? fullAddress;

  static Map<String, dynamic> create({
    required String athleteId,
    String? fullName,
    String? taxCode,
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

  Parent copyWith({
    String? athleteId,
    String? fullName,
    String? taxCode,
    String? email,
    String? phone,
    String? fullAddress,
    DateTime? createdAt,
  }) {
    return Parent(
      athleteId: athleteId ?? this.athleteId,
      fullName: fullName ?? this.fullName,
      taxCode: taxCode ?? this.taxCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullAddress: fullAddress ?? this.fullAddress,
    );
  }
}
