import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:payments_repository/payments_repository.dart';

part 'add_payment_state.dart';

/// Cubit for managing the state of adding a payment.
///
/// This Cubit handles the addition of a new payment and updates its state
/// based on the outcome of the operation.
class AddPaymentCubit extends Cubit<AddPaymentState> {
  /// Creates an instance of [AddPaymentCubit].
  ///
  /// [paymentsRepository] is required to interact with the payments data source.
  /// Optionally, an [athlete] and a [formula] can be provided to initialize the state.
  AddPaymentCubit({
    Athlete? athlete,
    PaymentFormula? formula,
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(AddPaymentState(formula: formula, athlete: athlete));

  final PaymentsRepository _paymentsRepository;

  /// Adds a new payment with the provided details.
  ///
  /// The [amount] is the amount of the payment.
  /// The [cause] is the reason for the payment.
  /// The [type] indicates the type of payment.
  /// The [method] specifies how the payment was made.
  /// Optionally, [formula] can be provided to use a specific payment formula.
  Future<void> addPayment({
    required double amount,
    required String cause,
    required PaymentType type,
    required PaymentMethod method,
    PaymentFormula? formula,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _paymentsRepository.addPayment(
        athleteId: state.athlete?.id,
        amount: amount,
        cause: cause,
        type: type,
        method: method,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
