import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:payments_repository/payments_repository.dart';

part 'add_formula_state.dart';

/// Cubit for managing the state of adding a new athlete.
class AddFormulaCubit extends Cubit<AddFormulaState> {
  /// Creates an [AddAthleteCubit].
  ///
  /// The [teamId] is required to associate the new athlete with a team.
  /// The [athletesRepository] is used to perform the actual addition of the athlete.
  AddFormulaCubit({
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(const AddFormulaState());

  final PaymentsRepository _paymentsRepository;

  Future<void> addPaymentFormula({
    required String name,
    required String amount1,
    required String date1,
    required bool full,
    String? amount2,
    String? date2,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _paymentsRepository.addPaymentFormula(
          name: name,
          full: full,
          amount1: num.parse(amount1),
          date1: date1.toDateTime!,
          amount2: num.tryParse(amount2 ?? ''),
          date2: date2?.toDateTime
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      log(error.toString());
      emit(state.copyWith(status: FormzSubmissionStatus.failure, error: 'Error adding payment formula'));
      addError(error, stackTrace);
    }
  }
}