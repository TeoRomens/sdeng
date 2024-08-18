import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:teams_repository/teams_repository.dart';

part 'add_team_state.dart';

/// Cubit for managing the state of adding a new team.
class AddTeamCubit extends Cubit<AddTeamState> {
  /// Creates an [AddTeamCubit].
  ///
  /// The [teamsRepository] is used to perform the actual addition of the team.
  AddTeamCubit({
    required TeamsRepository teamsRepository,
  })  : _teamsRepository = teamsRepository,
        super(const AddTeamState());

  final TeamsRepository _teamsRepository;

  /// Adds a new team with the provided [name].
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while adding the team,
  /// [FormzSubmissionStatus.success] if successful, or
  /// [FormzSubmissionStatus.failure] if an error occurs.
  Future<void> addTeam(String name) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _teamsRepository.addTeam(name: name);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
