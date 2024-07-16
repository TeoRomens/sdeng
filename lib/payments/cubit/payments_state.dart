part of 'payments_cubit.dart';

enum PaymentsStatus {
  initial,
  loading,
  populated,
  failure,
}

class PaymentsState extends Equatable {
  const PaymentsState({
    required this.status,
    this.payments = const [],
    this.error = '',
  });

  const PaymentsState.initial() : this(

    status: PaymentsStatus.initial,
  );

  final PaymentsStatus status;
  final List<Payment> payments;
  final String error;

  @override
  List<Object> get props => [
    status,
    payments,
    error,
  ];

  PaymentsState copyWith({
    PaymentsStatus? status,
    List<Payment>? payments,
    String? error,
  }) {
    return PaymentsState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      error: error ?? this.error,
    );
  }
}
