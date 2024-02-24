class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? billingAddress;
  final String? paymentMethod;
  final String? societyName;
  final String? societyAddress;
  final String? societyPhone;
  final String? societyEmail;
  final String? societyPiva;

  Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.billingAddress,
    this.paymentMethod,
    this.societyName,
    this.societyAddress,
    this.societyEmail,
    this.societyPhone,
    this.societyPiva
  });

  static Map<String, dynamic> create({
    String? fullName,
    String? societyName,
    String? societyEmail,
    String? societyPhone,
    String? societyAddress,
    String? societyPiva
  }) {
    return {
      'full_name': fullName,
      'society_name': societyName,
      'society_email': societyEmail,
      'society_phone': societyPhone,
      'society_address': societyAddress,
      'society_piva': societyPiva
    };
  }

  static List<Profile> fromList(List<Map<String, dynamic>> data) {
    return data.map(Profile.fromMap).toList();
  }

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        fullName = map['full_name'],
        avatarUrl = map['avatar_url'],
        billingAddress = map['billing_address'],
        paymentMethod = map['payment_method'],
        societyName = map['society_name'],
        societyEmail = map['society_email'],
        societyPhone = map['society_phone'],
        societyAddress = map['society_address'],
        societyPiva = map['society_piva']
  ;

  /// Converts `Profile` to a map so that it can be save to db.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (billingAddress != null) 'billing_address': billingAddress,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (societyName != null) 'society_name': societyName,
      if (societyEmail != null) 'society_email': societyEmail,
      if (societyPhone != null) 'society_phone': societyPhone,
      if (societyAddress != null) 'society_address': societyAddress,
      if (societyPiva != null) 'society_piva': societyPiva
    };
  }

  Profile copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? billingAddress,
    String? paymentMethod,
    String? societyName,
    String? societyAddress,
    String? societyPhone,
    String? societyEmail,
    String? societyPiva,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      billingAddress: billingAddress ?? this.billingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      societyName: societyName ?? this.societyName,
      societyEmail: societyEmail ?? this.societyEmail,
      societyAddress: societyAddress ?? this.societyAddress,
      societyPhone: societyPhone ?? this.societyPhone,
      societyPiva: societyPiva ?? this.societyPiva
    );
  }
}
