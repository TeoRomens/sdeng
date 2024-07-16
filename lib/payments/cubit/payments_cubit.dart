import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit({
    required PaymentsRepository paymentsRepository
  }) : _paymentsRepository = paymentsRepository,
       super(const PaymentsState.initial());

  final PaymentsRepository _paymentsRepository;

  Future<void> getPayments() async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    try {
      final payments = await _paymentsRepository.getPayments();
      emit(state.copyWith(
          status: PaymentsStatus.populated,
          payments: payments
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.failure));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> deleteTeam(String id) async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2));
      //await _teamsRepository.deleteTeam(id);
      state.payments.removeWhere((elem) => elem.id == id);
      emit(state.copyWith(status: PaymentsStatus.populated, payments: state.payments));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: PaymentsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
