/// A model class representing a Payment Formula.
///
/// This class is used to manage and manipulate payment formulas, which include
/// various quotas and associated dates. A payment formula typically consists
/// of a primary quota and date, with an optional secondary quota and date.
class PaymentFormula {
  /// Creates a [PaymentFormula] instance from a map.
  ///
  /// The [map] parameter must contain keys corresponding to the fields of this class.
  /// This constructor parses the map and assigns values to the fields accordingly.
  PaymentFormula.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        full = map['full'] as bool,
        quota1 = map['quota1'] as num,
        date1 = DateTime.parse(map['date1'] as String),
        quota2 = map['quota2'] as num?,
        date2 = DateTime.tryParse(map['date2'] as String? ?? '');

  /// Creates a new [PaymentFormula] instance.
  ///
  /// All fields are required, except for [quota2] and [date2], which are optional.
  PaymentFormula({
    required this.id,
    required this.name,
    required this.full,
    required this.date1,
    required this.quota1,
    this.date2,
    this.quota2,
  });

  /// Unique identifier for the payment formula.
  final String id;

  /// Name or title of the payment formula.
  final String name;

  /// Boolean flag indicating whether the formula is full.
  final bool full;

  /// The first quota associated with this payment formula.
  final num quota1;

  /// The first date associated with this payment formula.
  final DateTime date1;

  /// The optional second quota associated with this payment formula.
  final num? quota2;

  /// The optional second date associated with this payment formula.
  final DateTime? date2;

  /// Creates a map that can be used to create a [PaymentFormula] instance.
  ///
  /// This map is useful when preparing data for storage or serialization.
  /// The [name], [full], [quota1], and [date1] parameters are required.
  /// The [quota2] and [date2] parameters are optional.
  static Map<String, dynamic> create({
    required String name,
    required bool full,
    required num quota1,
    required DateTime date1,
    num? quota2,
    DateTime? date2,
  }) {
    return {
      'name': name,
      'full': full,
      'quota1': quota1,
      'quota2': quota2,
      'date1': date1.toIso8601String(),
      'date2': date2?.toIso8601String(),
    };
  }

  /// Creates a list of [PaymentFormula] instances from a list of maps.
  ///
  /// Each map in the [data] list must correspond to the structure expected by
  /// the [PaymentFormula.fromMap] constructor.
  static List<PaymentFormula> fromList(List<Map<String, dynamic>> data) {
    return data.map(PaymentFormula.fromMap).toList();
  }

  /// Creates a copy of this [PaymentFormula] instance with the specified changes.
  ///
  /// Any field that is not provided will retain its current value.
  PaymentFormula copyWith({
    String? id,
    String? name,
    bool? full,
    double? quota1,
    DateTime? date1,
    double? quota2,
    DateTime? date2,
  }) {
    return PaymentFormula(
      id: id ?? this.id,
      name: name ?? this.name,
      full: full ?? this.full,
      quota1: quota1 ?? this.quota1,
      date1: date1 ?? this.date1,
      quota2: quota2 ?? this.quota2,
      date2: date2 ?? this.date2,
    );
  }
}
