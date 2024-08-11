import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';

part 'edit_parent_state.dart';

class EditParentCubit extends Cubit<EditParentState> {
  EditParentCubit({
    required Parent parent,
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(EditParentState(parent: parent));

  final AthletesRepository _athletesRepository;

  Future<void> updateParent({
    String? name,
    String? surname,
    String? email,
    String? phone,
    String? address,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final updatedParent = state.parent.copyWith(
          fullName: '$name $surname',
          email: email,
          phone: phone,
          fullAddress: address);
      await _athletesRepository.updateParent(parent: updatedParent);
      emit(state.copyWith(
          status: FormzSubmissionStatus.success, parent: updatedParent));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
