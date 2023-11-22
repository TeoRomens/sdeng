import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/repositories/athletes_repository.dart';

part 'search_state.dart';

class SearchBloc extends Cubit<SearchState> {
  SearchBloc() : super(SearchState());

  final _athleteRepository = GetIt.I.get<AthletesRepository>();

  Future<void> search(String string) async {
    try{
      emit(state.copyWith(status: Status.loading));
      log('Starting search...');
      final results = await _athleteRepository.searchAthlete(string);
      log('${results.length} results found');
      emit(state.copyWith(results: results, status: Status.idle));
    } catch (e) {
      log(e.toString());
    }
  }

}