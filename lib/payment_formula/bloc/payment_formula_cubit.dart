import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';

part 'payment_formula_state.dart';

class PaymentFormulaCubit extends Cubit<PaymentFormulaState> {
  PaymentFormulaCubit({
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(const PaymentFormulaState.initial());

  final PaymentsRepository _paymentsRepository;

  Future<void> getPaymentFormulas({int? limit}) async {
    emit(state.copyWith(status: PaymentFormulaStatus.loading));
    try {
      final paymentFormulas = await _paymentsRepository.getPaymentFormulas(
        limit: limit,
      );
      emit(state.copyWith(
          status: PaymentFormulaStatus.loaded,
          paymentsFormulas: paymentFormulas
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentFormulaStatus.failure));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> addPaymentFormula({
    required String name,
    required bool full,
    required num amount1,
    required DateTime date1,
    num? amount2,
    DateTime? date2,
  }) async {
    emit(state.copyWith(status: PaymentFormulaStatus.loading));
    try {
      final paymentFormula = await _paymentsRepository.addPaymentFormula(
          name: name,
          full: full,
          amount1: amount1,
          date1: date1,
          amount2: amount2,
          date2: date2
      );
      state.paymentsFormulas.add(paymentFormula);
      emit(state.copyWith(status: PaymentFormulaStatus.loaded, paymentsFormulas: state.paymentsFormulas));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentFormulaStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> updatePaymentFormula({
    required String id,
    required String name,
    required bool full,
    required num amount1,
    required DateTime date1,
    num? amount2,
    DateTime? date2,
  }) async {
    emit(state.copyWith(status: PaymentFormulaStatus.loading));
    try {
      await _paymentsRepository.updatePaymentFormula(
          id: id,
          name: name,
          full: full,
          amount1: amount1,
          date1: date1,
          amount2: amount2,
          date2: date2
      );
      emit(state.copyWith(status: PaymentFormulaStatus.loaded));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentFormulaStatus.failure));
      addError(error, stackTrace);
    }
  }

}
