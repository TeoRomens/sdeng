import 'dart:async';
import 'dart:developer';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'athletes_state.dart';

class AthletesPageCubit extends Cubit<AthletesPageState> {
  AthletesPageCubit({
    required AthletesRepository athletesRepository,
  }) : _athletesRepository = athletesRepository,
       super(const AthletesPageState.initial());

  final AthletesRepository _athletesRepository;

  Future<void> getAthletes({int? offset}) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      final currentAthletes = state.athletes;
      final newAthletes = await _athletesRepository.getAthletes(
        limit: 20,
        offset: offset
      );
      final List<Athlete> athletes = List.from(currentAthletes)..addAll(newAthletes);

      emit(state.copyWith(
          status: AthletesStatus.populated,
          athletes: athletes,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthletesStatus.failure, error: 'Error loading athletes.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  Future<void> searchAthlete(String searchText) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      final results = await _athletesRepository.searchAthletes(searchText);

      emit(state.copyWith(
        status: AthletesStatus.populated,
        athletes: results,
      ));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: AthletesStatus.failure, error: 'Error searcing athletes.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }
}
