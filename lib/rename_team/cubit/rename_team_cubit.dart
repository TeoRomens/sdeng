import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:teams_repository/teams_repository.dart';

part 'rename_team_state.dart';

class RenameTeamCubit extends Cubit<RenameTeamState> {
  RenameTeamCubit({
    required Team team,
    required TeamsRepository teamsRepository,
  })  : _teamsRepository = teamsRepository,
        super(RenameTeamState(team: team));

  final TeamsRepository _teamsRepository;

  Future<void> rename({required String name}) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final updatedTeam = state.team.copyWith(name: name);
      await _teamsRepository.updateTeam(team: updatedTeam);
      emit(state.copyWith(
          status: FormzSubmissionStatus.success, team: updatedTeam));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: 'Error updating medical visit'));
      addError(error, stackTrace);
    }
  }
}
