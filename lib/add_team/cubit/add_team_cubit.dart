import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:teams_repository/teams_repository.dart';

part 'add_team_state.dart';

class AddTeamCubit extends Cubit<AddTeamState> {
  AddTeamCubit({
    required TeamsRepository teamsRepository,
  })  : _teamsRepository = teamsRepository,
        super(const AddTeamState());

  final TeamsRepository _teamsRepository;

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
