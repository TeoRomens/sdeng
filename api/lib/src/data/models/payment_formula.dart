class PaymentFormula {
  PaymentFormula(
      {required this.id,
      required this.name,
      required this.full,
      required this.date1,
      required this.quota1,
      this.date2,
      this.quota2});

  final String id;
  final String name;
  final bool full;
  final num quota1;
  final DateTime date1;
  final num? quota2;
  final DateTime? date2;

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

  static List<PaymentFormula> fromList(List<Map<String, dynamic>> data) {
    return data.map(PaymentFormula.fromMap).toList();
  }

  PaymentFormula.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        name = map['name'] as String,
        full = map['full'] as bool,
        quota1 = map['quota1'] as num,
        date1 = DateTime.parse(map['date1'] as String),
        quota2 = map['quota2'] as num?,
        date2 = DateTime.tryParse(map['date2'] as String? ?? '');

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
