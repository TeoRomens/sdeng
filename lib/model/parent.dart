class Parent {
  final String id;
  final String fullName;
  final String taxCode;
  final String? email;
  final String? phone;
  final String? fullAddress;
  final bool? archived;

  Parent({
    required this.id,
    required this.fullName,
    required this.taxCode,
    this.email,
    this.phone,
    this.fullAddress,
    this.archived,
  });

  static Map<String, dynamic> create({
    required String fullName,
    required String taxCode,
    String? email,
    String? phone,
    String? fullAddress,
    bool? archived,
  }) {
    return {
      'full_name': fullName,
      'tax_code': taxCode,
      'email': email,
      'phone': phone,
      'full_address': fullAddress,
      'archived': archived ?? false,
    };
  }

  static List<Parent> fromList(List<Map<String, dynamic>> data) {
    return data.map(Parent.fromMap).toList();
  }

  Parent.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        fullName = map['full_name'],
        taxCode = map['tax_code'],
        email = map['email'],
        phone = map['phone'],
        fullAddress = map['full_address'],
        archived = map['archived']
  ;

  Parent copyWith({
    String? id,
    String? fullName,
    String? taxCode,
    String? email,
    String? phone,
    String? fullAddress,
    bool? archived,
    DateTime? createdAt,
  }) {
    return Parent(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      taxCode: taxCode ?? this.taxCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullAddress: fullAddress ?? this.fullAddress,
      archived: archived ?? this.archived,
    );
  }
}