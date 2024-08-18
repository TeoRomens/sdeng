import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:medicals_repository/medicals_repository.dart';

part 'add_medical_state.dart';

/// Cubit for managing the state of adding a medical record.
///
/// This cubit handles the process of adding a new medical record for an athlete.
/// It communicates with the [MedicalsRepository] to perform the operation
/// and updates its state based on the result.
class AddMedicalCubit extends Cubit<AddMedicalState> {
  /// Creates an instance of [AddMedicalCubit].
  ///
  /// The [teamId] parameter represents the athlete's ID, and the
  /// [medicalsRepository] is used to interact with the medical records data source.
  AddMedicalCubit({
    required String athleteId,
    required MedicalsRepository medicalsRepository,
  })  : _medicalsRepository = medicalsRepository,
        super(AddMedicalState(athleteId: athleteId));

  final MedicalsRepository _medicalsRepository;

  /// Adds a new medical record for the athlete.
  ///
  /// Sets the cubit's state to `inProgress` while the record is being added.
  /// On success, updates the state to `success`. On failure, sets the state to
  /// `failure` and logs the error.
  ///
  /// Parameters:
  /// - [type]: The type of medical record.
  /// - [expire]: The expiration date of the medical record.
  Future<void> addMedical({
    required MedType type,
    required DateTime expire,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _medicalsRepository.addMedical(
        athleteId: state.athleteId,
        expire: expire,
        type: type,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        error: 'Error adding medical',
      ));
      addError(error, stackTrace);
    }
  }
}
