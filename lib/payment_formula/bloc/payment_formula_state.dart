part of 'payment_formula_cubit.dart';

enum PaymentFormulaStatus {
  initial,
  loading,
  loaded,
  failure,
}

class PaymentFormulaState extends Equatable {
  const PaymentFormulaState({
    required this.status,
    required this.paymentsFormulas,
    this.error = '',
  });

  const PaymentFormulaState.initial()
      : this(
            status: PaymentFormulaStatus.initial,
            paymentsFormulas: const [],
            error: '');

  final PaymentFormulaStatus status;
  final List<PaymentFormula> paymentsFormulas;
  final String error;

  @override
  List<Object?> get props => [status, paymentsFormulas];

  PaymentFormulaState copyWith({
    PaymentFormulaStatus? status,
    List<PaymentFormula>? paymentsFormulas,
    String? error,
  }) =>
      PaymentFormulaState(
        status: status ?? this.status,
        paymentsFormulas: paymentsFormulas ?? this.paymentsFormulas,
        error: error ?? this.error,
      );
}
