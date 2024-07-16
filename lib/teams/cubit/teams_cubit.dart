import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teams_repository/teams_repository.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit({
    required TeamsRepository teamsRepository
  }) : _teamsRepository = teamsRepository,
       super(const TeamsState.initial());

  final TeamsRepository _teamsRepository;

  Future<void> getTeams() async {
    emit(state.copyWith(status: TeamsStatus.loading));
    try {
      final teams = await _teamsRepository.getTeams();
      final teamsWithAthletes = <Team>[];
      int totAthletes = 0;
      for(var team in teams) {
        final num = await _teamsRepository.countAthletesInTeam(id: team.id);
        totAthletes = totAthletes + num;
        teamsWithAthletes.add(team.copyWith(numAthletes: num));
      }
      emit(state.copyWith(
          status: TeamsStatus.populated,
          teams: teamsWithAthletes,
          numAthletes: totAthletes
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: TeamsStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> addTeam(String name) async {
    emit(state.copyWith(status: TeamsStatus.loading));
    try {
      final team = await _teamsRepository.addTeam(name: name);
      state.teams.add(team);
      emit(state.copyWith(status: TeamsStatus.populated, teams: state.teams));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: TeamsStatus.failure));
      addError(error, stackTrace);
    }
  }
}
