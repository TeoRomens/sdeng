import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/repositories/repository.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit({required Repository repository})
      : _repository = repository,
        super(TeamsInitial());

  final Repository _repository;

  /// Map of app teams cache in memory with team_id as the key
  Map<String, Team> _teams = {};

  Future<void> loadTeamFromId(String id) async {
    if (_teams[id] != null) {
      return;
    }
    try {
      emit(TeamsLoading());
      final team = await _repository.loadTeamFromId(id);
      _teams[team.id] = team;
      emit(TeamsLoaded(teams: _teams));
    } catch (e) {
      emit(TeamsError(error: 'Error loading team. Please refresh.'));
      log(e.toString());
    }
  }

  Future<void> loadTeams() async {
    try {
      emit(TeamsLoading());
      final teams = await _repository.loadTeams();
      _teams = teams;
      emit(TeamsLoaded(teams: _teams));
    } catch (err) {
      emit(TeamsError(error: 'Error loading teams. Please refresh.'));
    }
  }

  Future<void> addTeam(String name) async {
    try {
      await _repository.addTeam(name: name);
      emit(TeamsLoaded(teams: _teams));
    } catch (e) {
      emit(TeamsError(error: 'Error adding team. Please retry.'));
    }

  }
}
