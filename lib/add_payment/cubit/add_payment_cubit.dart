import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:payments_repository/payments_repository.dart';

part 'add_payment_state.dart';

class AddPaymentCubit extends Cubit<AddPaymentState> {
  AddPaymentCubit({
    Athlete? athlete,
    PaymentFormula? formula,
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(AddPaymentState(formula: formula, athlete: athlete));

  final PaymentsRepository _paymentsRepository;

  Future<void> addPayment({
    required double amount,
    required String cause,
    required PaymentType type,
    required PaymentMethod method,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _paymentsRepository.addPayment(
          athleteId: state.athlete?.id,
          amount: amount,
          cause: cause,
          type: type,
          method: method
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

}
