import 'dart:async';
import 'dart:developer';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'athletes_state.dart';

/// A [Cubit] that manages the state of the athletes' data on a page,
/// including fetching and searching athletes from a repository.
class AthletesPageCubit extends Cubit<AthletesPageState> {
  /// Creates an instance of [AthletesPageCubit].
  ///
  /// The [athletesRepository] is required and will be used to fetch and search athletes.
  AthletesPageCubit({
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(const AthletesPageState.initial());

  /// The repository that provides access to the athletes data.
  final AthletesRepository _athletesRepository;

  /// Fetches a list of athletes with pagination.
  ///
  /// The [offset] parameter allows for fetching athletes from a specific
  /// position in the list, supporting pagination. By default, it starts from the beginning.
  /// Emits [AthletesStatus.loading] while fetching data,
  /// and [AthletesStatus.populated] when data is successfully loaded.
  /// If an error occurs, it emits [AthletesStatus.failure].
  Future<void> getAthletes({int? offset}) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      final currentAthletes = state.athletes;
      // Fetches a new set of athletes from the repository.
      final newAthletes =
      await _athletesRepository.getAthletes(limit: 20, offset: offset);
      // Combines the existing athletes with the newly fetched ones.
      final List<Athlete> athletes = List.from(currentAthletes)
        ..addAll(newAthletes);

      // Updates the state with the populated list of athletes.
      emit(state.copyWith(
        status: AthletesStatus.populated,
        athletes: athletes,
      ));
    } catch (error, stackTrace) {
      // Logs the error and updates the state to indicate failure.
      emit(state.copyWith(
          status: AthletesStatus.failure, error: 'Error loading athletes.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }

  /// Searches for athletes based on the provided [searchText].
  ///
  /// Emits [AthletesStatus.loading] while searching,
  /// and [AthletesStatus.populated] when data is successfully loaded.
  /// If an error occurs, it emits [AthletesStatus.failure].
  Future<void> searchAthlete(String searchText) async {
    emit(state.copyWith(status: AthletesStatus.loading));
    try {
      // Searches for athletes in the repository based on the search text.
      final results = await _athletesRepository.searchAthletes(searchText);

      // Updates the state with the search results.
      emit(state.copyWith(
        status: AthletesStatus.populated,
        athletes: results,
      ));
    } catch (error, stackTrace) {
      // Logs the error and updates the state to indicate failure.
      emit(state.copyWith(
          status: AthletesStatus.failure, error: 'Error searching athletes.'));
      log(error.toString());
      addError(error, stackTrace);
    }
  }
}
