import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teams_repository/teams_repository.dart';

part 'teams_state.dart';

/// `TeamsCubit` is responsible for managing the state of teams in the application.
/// It communicates with the `TeamsRepository` to perform actions like fetching teams,
/// adding a new team, and counting the number of athletes in each team.
class TeamsCubit extends Cubit<TeamsState> {
  /// Creates a `TeamsCubit` instance with a required [TeamsRepository].
  TeamsCubit({required TeamsRepository teamsRepository})
      : _teamsRepository = teamsRepository,
        super(const TeamsState.initial());

  final TeamsRepository _teamsRepository;

  /// Fetches the list of teams and their respective number of athletes.
  ///
  /// Emits [TeamsStatus.loading] while the data is being fetched.
  /// On success, emits [TeamsStatus.populated] with the list of teams and total number of athletes.
  /// On failure, emits [TeamsStatus.failure].
  Future<void> getTeams() async {
    emit(state.copyWith(status: TeamsStatus.loading));
    try {
      final teams = await _teamsRepository.getTeams();
      final teamsWithAthletes = <Team>[];
      int totAthletes = 0;
      for (var team in teams) {
        final num = await _teamsRepository.countAthletesInTeam(id: team.id);
        totAthletes = totAthletes + num;
        teamsWithAthletes.add(team.copyWith(numAthletes: num));
      }
      emit(state.copyWith(
          status: TeamsStatus.populated,
          teams: teamsWithAthletes,
          numAthletes: totAthletes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: TeamsStatus.failure, error: 'Error loading teams.'));
      addError(error, stackTrace);
    }
  }

  /// Adds a new team with the given [name].
  ///
  /// Emits [TeamsStatus.loading] while the team is being added.
  /// On success, emits [TeamsStatus.populated] with the updated list of teams.
  /// On failure, emits [TeamsStatus.failure].
  Future<void> addTeam({required String name}) async {
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
