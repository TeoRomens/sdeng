import 'dart:async';
import 'dart:developer';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teams_repository/teams_repository.dart';

part 'athletes_state.dart';

/// `AthletesCubit` manages the state of athletes associated with a team,
/// including fetching, deleting athletes, and deleting the team.
class AthletesCubit extends Cubit<AthletesState> {
  /// Constructs an [AthletesCubit] with the required repositories and initial team state.
  AthletesCubit({
    required AthletesRepository athletesRepository,
    required TeamsRepository teamsRepository,
    required Team team,
  })  : _athletesRepository = athletesRepository,
        _teamsRepository = teamsRepository,
        super(AthletesState.initial(team: team));

  final AthletesRepository _athletesRepository;
  final TeamsRepository _teamsRepository;

  /// Fetches athletes associated with a given team by [teamId].
  ///
  /// Emits [AthletesStatus.loading] while loading and either
  /// [AthletesStatus.populated] or [AthletesStatus.failure]
  /// depending on the outcome.
  Future<void> getAthletesFromTeam(String teamId) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      final athletes = await _athletesRepository.getAthletesFromTeamId(teamId: teamId);
      emit(state.copyWith(status: AthletesStatus.populated, athletes: athletes));
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      emit(state.copyWith(
          status: AthletesStatus.failure, error: 'Error loading athletes.'));
      addError(error, stackTrace);
    }
  }

  /// Deletes an athlete by [id].
  ///
  /// Emits [AthletesStatus.loading] during the process and either
  /// [AthletesStatus.populated] or [AthletesStatus.failure]
  /// depending on the outcome.
  Future<void> deleteAthlete(String id) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      await _athletesRepository.deleteAthlete(id: id);
      final updatedAthletes = List.of(state.athletes)
        ..removeWhere((athlete) => athlete.id == id);
      emit(state.copyWith(status: AthletesStatus.populated, athletes: updatedAthletes));
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      emit(state.copyWith(status: AthletesStatus.failure));
      addError(error, stackTrace);
    }
  }

  /// Deletes a team by [id] after ensuring no athletes are associated with it.
  ///
  /// Emits [AthletesStatus.loading] during the process and either
  /// [AthletesStatus.teamDeleted] or [AthletesStatus.failure]
  /// depending on the outcome.
  ///
  /// If the team still has associated athletes, an error is emitted.
  Future<void> deleteTeam(String id) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      if (state.athletes.isNotEmpty) {
        emit(state.copyWith(
            status: AthletesStatus.failure,
            error: 'Error deleting team. Delete all athletes before deleting.'));
        emit(state.copyWith(status: AthletesStatus.populated, error: 'You must empty the team before deleting it'));
        return;
      }
      await _teamsRepository.deleteTeam(id: id);
      emit(state.copyWith(status: AthletesStatus.teamDeleted));
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      emit(state.copyWith(
          status: AthletesStatus.failure, error: 'Error deleting team.'));
      addError(error, stackTrace);
    }
  }
}
