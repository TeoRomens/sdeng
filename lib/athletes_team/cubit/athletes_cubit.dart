import 'dart:async';
import 'dart:developer';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:teams_repository/teams_repository.dart';

part 'athletes_state.dart';

class AthletesCubit extends Cubit<AthletesState> {
  AthletesCubit({
    required AthletesRepository athletesRepository,
    required TeamsRepository teamsRepository,
    required Team team,
  }) : _athletesRepository = athletesRepository,
       _teamsRepository = teamsRepository,
       super(AthletesState.initial(team: team));

  final AthletesRepository _athletesRepository;
  final TeamsRepository _teamsRepository;

  void refresh() {
    emit(state.copyWith());
  }

  Future<void> getAthletesFromTeam(String teamId) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      final athletes = await _athletesRepository.getAthletesFromTeamId(
          teamId: teamId
      );
      emit(state.copyWith(
          status: AthletesStatus.populated,
          athletes: athletes
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthletesStatus.failure, error: 'Error loading athletes.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> deleteAthlete(String id) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      await _athletesRepository.deleteAthlete(id: id);
      state.athletes.removeWhere((elem) => elem.id == id);
      emit(state.copyWith(status: AthletesStatus.populated, athletes: state.athletes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthletesStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> deleteTeam(String id) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      if(state.status == AthletesStatus.populated && state.athletes.isNotEmpty) {
        emit(state.copyWith(status: AthletesStatus.failure, error: 'Error deleting team. Delete all athletes before deleting.'));
        emit(state.copyWith(status: AthletesStatus.populated, error: ''));
        return;
      }
      await _teamsRepository.deleteTeam(id: id);
      emit(state.copyWith(status: AthletesStatus.teamDeleted));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthletesStatus.failure, error: 'Error deleting team.'));
      addError(error, stackTrace);
    }
  }
}
