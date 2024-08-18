/// Enum representing the type of a payment.
///
/// [PaymentType.income] represents incoming funds (e.g., revenue).
/// [PaymentType.expense] represents outgoing funds (e.g., costs).
enum PaymentType { income, expense }

/// Enum representing the method of payment.
///
/// [PaymentMethod.cash] represents payments made in cash.
/// [PaymentMethod.transfer] represents payments made via bank transfer.
/// [PaymentMethod.other] represents any other form of payment.
enum PaymentMethod { cash, transfer, other }

/// A model class representing a Payment.
///
/// This class contains information about a payment transaction,
/// including its ID, the associated athlete's ID, amount, cause, payment method, type,
/// and the date the payment was created.
class Payment {
  /// Creates a [Payment] instance from a map.
  ///
  /// The [map] parameter must contain keys corresponding to the fields of this class.
  /// This constructor parses the map and assigns values to the fields accordingly.
  Payment.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        athleteId = map['athlete_id'] as String?,
        amount = map['amount'] as double,
        cause = map['cause'] as String,
        method = PaymentMethod.values.firstWhere(
              (element) => element.name == map['method'] as String,
        ),
        type = PaymentType.values.firstWhere(
              (element) => element.name == map['type'] as String,
        ),
        createdAt = DateTime.parse(map['created_at'] as String);

  /// Creates a new [Payment] instance.
  ///
  /// All fields are required, except for [athleteId] which is optional.
  Payment({
    required this.id,
    required this.athleteId,
    required this.cause,
    required this.amount,
    required this.method,
    required this.type,
    required this.createdAt,
  });

  /// Unique identifier for the payment.
  final String id;

  /// Identifier of the associated athlete. Can be `null`.
  final String? athleteId;

  /// The amount of money involved in the payment.
  final double amount;

  /// A description or reason for the payment.
  final String cause;

  /// The method used for the payment (e.g., cash, transfer).
  final PaymentMethod method;

  /// The type of payment (income or expense).
  final PaymentType type;

  /// The date and time when the payment was created.
  final DateTime createdAt;

  /// Creates a map that can be used to create a [Payment] instance.
  ///
  /// This map is useful when preparing data for storage or serialization.
  /// The [cause], [amount], [type], and [method] parameters are required.
  /// The [athleteId] parameter is optional.
  static Map<String, dynamic> create({
    required String cause,
    required double amount,
    required PaymentType type,
    required PaymentMethod method,
    String? athleteId,
  }) {
    return {
      'athlete_id': athleteId,
      'amount': amount,
      'cause': cause,
      'method': method.name,
      'type': type.name,
    };
  }

  /// Creates a list of [Payment] instances from a list of maps.
  ///
  /// Each map in the [data] list must correspond to the structure expected by the [Payment.fromMap] constructor.
  static List<Payment> fromList(List<Map<String, dynamic>> data) {
    return data.map(Payment.fromMap).toList();
  }

  /// Creates a copy of this [Payment] instance with the specified changes.
  ///
  /// Any field that is not provided will retain its current value.
  Payment copyWith({
    String? id,
    String? athleteId,
    double? amount,
    String? cause,
    DateTime? cashedDate,
    PaymentMethod? method,
    PaymentType? type,
    DateTime? createdAt,
  }) {
    return Payment(
      id: id ?? this.id,
      athleteId: athleteId ?? this.athleteId,
      amount: amount ?? this.amount,
      cause: cause ?? this.cause,
      method: method ?? this.method,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
