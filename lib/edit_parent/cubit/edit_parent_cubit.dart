import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'edit_parent_state.dart';

/// Manages the state for editing a parent entity.
///
/// This Cubit handles the process of updating a parent record and manages
/// the loading, success, and error states during the update operation.
class EditParentCubit extends Cubit<EditParentState> {
  /// Creates an [EditParentCubit] instance.
  ///
  /// The [parent] parameter represents the parent entity to be edited.
  /// The [athletesRepository] is used to perform the update operation.
  EditParentCubit({
    required Parent parent,
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(EditParentState(parent: parent));

  final AthletesRepository _athletesRepository;

  /// Updates the parent entity with new values.
  ///
  /// [name], [surname], [email], [phone], and [address] are optional parameters
  /// that will be used to update the respective fields of the parent entity.
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
        fullAddress: address,
      );
      await _athletesRepository.updateParent(parent: updatedParent);
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        parent: updatedParent,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        error: 'Error updating parent information',
      ));
      addError(error, stackTrace);
    }
  }
}
