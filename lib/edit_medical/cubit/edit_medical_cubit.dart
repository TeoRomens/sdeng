import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:medicals_repository/medicals_repository.dart';

part 'edit_medical_state.dart';

/// A Cubit responsible for managing the state of editing a medical record.
///
/// This Cubit handles the state of the `EditMedicalForm` and provides methods
/// to update the medical record using the `MedicalsRepository`.
class EditMedicalCubit extends Cubit<EditMedicalState> {
  /// Creates an instance of [EditMedicalCubit].
  ///
  /// The [medical] parameter initializes the state with the current medical record,
  /// and [medicalsRepository] is used to perform updates on the medical record.
  EditMedicalCubit({
    required Medical medical,
    required MedicalsRepository medicalsRepository,
  })  : _medicalsRepository = medicalsRepository,
        super(EditMedicalState(medical: medical));

  final MedicalsRepository _medicalsRepository;

  /// Updates the medical record with the provided parameters.
  ///
  /// Emits an [inProgress] status while the update is in progress. Upon success,
  /// the state is updated with the new medical record and a success status.
  /// If the update fails, the state is updated with a failure status and an error message.
  ///
  /// Parameters:
  /// - [expire]: The new expiration date for the medical record.
  /// - [medType]: The new type of the medical record.
  Future<void> updateMedical({
    DateTime? expire,
    MedType? medType,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final updatedMedical = state.medical.copyWith(
        expirationDate: expire,
        type: medType,
      );
      await _medicalsRepository.updateMedical(medical: updatedMedical);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        medical: updatedMedical,
      ));
    } catch (error, stackTrace) {
      // Emit a failure status with an error message
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        error: 'Error updating medical visit',
      ));

      // Add the error and stack trace to the error log
      addError(error, stackTrace);
    }
  }
}
