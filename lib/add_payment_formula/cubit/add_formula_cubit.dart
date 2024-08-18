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
    required String teamId,
    required PaymentsRepository paymentsRepository,
  })  : _paymentsRepository = paymentsRepository,
        super(const AddFormulaState());

  final PaymentsRepository _paymentsRepository;

  Future<void> addPaymentFormula() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _paymentsRepository.addPaymentFormula(
          name: state.name.value,
          full: state.full,
          amount1: int.parse(state.amount1.value),
          date1: DateTime.parse(state.date1.value),
          amount2: int.tryParse(state.amount2.value),
          date2: DateTime.tryParse(state.date2.value)
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, error: 'Error adding payment formula'));
      addError(error, stackTrace);
    }
  }
}