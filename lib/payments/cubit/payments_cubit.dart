import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';

part 'payments_state.dart';

/// A Cubit that manages the state of payments, handling retrieval and deletion operations.
class PaymentsCubit extends Cubit<PaymentsState> {
  /// Creates a new instance of [PaymentsCubit] with the provided [paymentsRepository].
  PaymentsCubit({required PaymentsRepository paymentsRepository})
      : _paymentsRepository = paymentsRepository,
        super(const PaymentsState.initial());

  final PaymentsRepository _paymentsRepository;

  /// Fetches the list of payments from the repository and updates the state accordingly.
  Future<void> getPayments() async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    try {
      final payments = await _paymentsRepository.getPayments();
      emit(state.copyWith(
        status: PaymentsStatus.populated,
        payments: payments,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.failure, error: 'Error fetching payments'));
      addError(error, stackTrace);
    }
  }

  /// Deletes a payment with the given [id] and updates the state.
  ///
  /// This method simulates a delay to represent an asynchronous operation.
  Future<void> deletePayment(String id) async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    try {
      await _paymentsRepository.deletePayment(id);

      final updatedPayments = List<Payment>.from(state.payments)
        ..removeWhere((payment) => payment.id == id);

      emit(state.copyWith(
        status: PaymentsStatus.populated,
        payments: updatedPayments,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.failure, error: 'Error deleting payment'));
      addError(error, stackTrace);
    }
  }
}
