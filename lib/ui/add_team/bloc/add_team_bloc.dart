import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:sdeng/repositories/teams_repository.dart';

part 'add_team_state.dart';

class AddTeamBloc extends Cubit<AddTeamState> {
  AddTeamBloc() : super(AddTeamState());

  final TeamsRepository _teamRepository = Get.find();

  nameChangedEventHandler(String name) async {
    emit(state.copyWith(name: name));
  }

  Future<void> submittedEventHandler() async {
    try {
      emit(state.copyWith(status: Status.submitting));
      log('Submitting new team...');
      if(await _teamRepository.checkName(state.name)) {
        await _teamRepository.addTeam(state.name);
        log('Team Added!');
        emit(state.copyWith(status: Status.success));
      } else {
        log('Team name already used :(');
        emit(state.copyWith(status: Status.failure));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: Status.failure));
    }
  }

}
