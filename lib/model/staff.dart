enum Role {
  admin,
  trainer,
  secretary,
  viewer
}

class Staff {
  final String id;
  final String fullName;
  final String taxCode;
  final String email;
  final Role role;

  Staff({
    required this.id,
    required this.fullName,
    required this.taxCode,
    required this.email,
    required this.role
  });

  static Map<String, dynamic> create({
    required String fullName,
    required String taxCode,
    required String email,
    required Role role,
  }) {
    return {
      'full_name': fullName,
      'tax_code': taxCode,
      'email': email,
      'role': role
    };
  }

  static List<Staff> fromList(List<Map<String, dynamic>> data) {
    return data.map(Staff.fromMap).toList();
  }

  Staff.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        id = map['id'],
        fullName = map['full_name'],
        taxCode = map['tax_code'],
        role = Role.values.firstWhere((element) => element.name == map['role'])
  ;

  Staff copyWith({
    String? id,
    String? email,
    String? fullName,
    String? taxCode,
    Role? role
  }) {
    return Staff(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      taxCode: taxCode ?? this.taxCode,
      role: role ?? this.role,
    );
  }
}
