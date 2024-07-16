import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:medicals_repository/medicals_repository.dart';

part 'edit_medical_state.dart';

class EditMedicalCubit extends Cubit<EditParentState> {
  EditMedicalCubit({
    required Medical medical,
    required MedicalsRepository medicalsRepository,
  })  : _medicalsRepository = medicalsRepository,
        super(EditParentState(medical: medical));

  final MedicalsRepository _medicalsRepository;

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
      await _medicalsRepository.updateMedical(
          medical: updatedMedical
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success, medical: updatedMedical));
    } catch (error, stackTrace) {
      print(error);
      emit(state.copyWith(status: FormzSubmissionStatus.failure, error: 'Error updating medical visit'));
      addError(error, stackTrace);
    }
  }

}
