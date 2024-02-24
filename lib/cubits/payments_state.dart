part of 'payments_cubit.dart';

@immutable
abstract class PaymentsState {}

class PaymentsInitial extends PaymentsState {}

class PaymentsEmpty extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsError extends PaymentsState {
  PaymentsError({
    required this.error,
  });

  final String error;
}

class PaymentsLoaded extends PaymentsState {
  PaymentsLoaded({
    required this.payments,
  });

  final List<Payment> payments;
}
