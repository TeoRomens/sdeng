/// A class representing a user in the application.
class SdengUser {
  /// Creates an instance of [SdengUser].
  ///
  /// The [id] parameter is required and represents the user's unique identifier.
  /// Other parameters such as [fullName], [societyName], [societyPiva],
  /// [societyAddress], [societyPhone], and [societyEmail] are optional.
  const SdengUser({
    required this.id,
    this.fullName,
    this.societyName,
    this.societyPiva,
    this.societyAddress,
    this.societyPhone,
    this.societyEmail,
  });

  /// Creates an instance of [SdengUser] from a map.
  ///
  /// The map should contain keys corresponding to the user's fields.
  SdengUser.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        fullName = map['full_name'] as String?,
        societyName = map['society_name'] as String?,
        societyPiva = map['society_piva'] as String?,
        societyAddress = map['society_address'] as String?,
        societyPhone = map['society_phone'] as String?,
        societyEmail = map['society_email'] as String?;

  /// The user's unique identifier.
  final String id;

  /// The user's full name.
  final String? fullName;

  /// The name of the user's society.
  final String? societyName;

  /// The PIVA (tax code) of the user's society.
  final String? societyPiva;

  /// The address of the user's society.
  final String? societyAddress;

  /// The phone number of the user's society.
  final String? societyPhone;

  /// The email address of the user's society.
  final String? societyEmail;

  /// Whether the current user is anonymous.
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = SdengUser(id: '');

  /// Creates a map from the current instance of [SdengUser].
  ///
  /// This method is useful for converting the user object to a map format
  /// which can be used for database operations.
  static Map<String, dynamic> create({
    required String id,
    String? fullName,
    String? societyName,
    String? societyPiva,
    String? societyAddress,
    String? societyPhone,
    String? societyEmail,
  }) {
    return {
      'id': id,
      'full_name': fullName,
      'society_name': societyName,
      'society_piva': societyPiva,
      'society_address': societyAddress,
      'society_phone': societyPhone,
      'society_email': societyEmail,
    };
  }

  /// Creates a list of [SdengUser] objects from a list of maps.
  ///
  /// Each map in the list should contain keys corresponding to the user's fields.
  static List<SdengUser> fromList(List<Map<String, dynamic>> data) {
    return data.map(SdengUser.fromMap).toList();
  }

  /// Creates a copy of the current instance with updated fields.
  ///
  /// This method is useful for creating a new instance of [SdengUser] with some
  /// fields updated while keeping the rest unchanged.
  SdengUser copyWith({
    String? id,
    String? fullName,
    String? societyName,
    String? societyPiva,
    String? societyAddress,
    String? societyPhone,
    String? societyEmail,
  }) {
    return SdengUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      societyName: societyName ?? this.societyName,
      societyPiva: societyPiva ?? this.societyPiva,
      societyAddress: societyAddress ?? this.societyAddress,
      societyPhone: societyPhone ?? this.societyPhone,
      societyEmail: societyEmail ?? this.societyEmail,
    );
  }
}
