import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/util/ui_utils.dart';

part 'search_state.dart';

class SearchBloc extends Cubit<SearchState> {
  SearchBloc() : super(SearchState());

  final AthletesRepository _athleteRepository = Get.find();

  Future<void> search(String string) async {
    try{
      if(string.length < 3){
        UIUtils.showError('Insert at least 3 characters');
        return;
      }
      log('Starting search...');
      final results = await _athleteRepository.searchAthlete(string);
      log('${results.length} results found');
      emit(state.copyWith(results: results));
    } catch (e) {
      log(e.toString());
    }
  }

}