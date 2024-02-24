import 'package:sdeng/model/medical.dart';

enum PaymentType{
  income,
  expense
}

enum PaymentMethod{
  cash,
  transfer,
  other
}

class Payment {

  Payment({
    required this.id,
    required this.athleteId,
    required this.cause,
    required this.amount,
    required this.method,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String athleteId;
  final int amount;
  final String cause;
  final PaymentMethod method;
  final PaymentType type;
  final DateTime createdAt;

  static Map<String, dynamic> create({
    required String athleteId,
    required String cause,
    required int amount,
    required PaymentType type,
    required PaymentMethod method
  }) {
    return {
      'athlete_id': athleteId,
      'amount': amount,
      'cause': cause,
      'method': method.name,
      'type': type.name,
    };
  }

  static List<Payment> fromList(List<Map<String, dynamic>> data) {
    return data.map(Payment.fromMap).toList();
  }

  Payment.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        athleteId = map['athlete_id'],
        amount = map['amount'],
        cause = map['cause'],
        method = PaymentMethod.values.firstWhere((element) => element.name == map['method']),
        type = PaymentType.values.firstWhere((element) => element.name == map['type']),
        createdAt = DateTime.parse(map['created_at'])
  ;

  Payment copyWith({
    String? id,
    String? athleteId,
    int? amount,
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
      createdAt: createdAt ?? this.createdAt
    );
  }
}
