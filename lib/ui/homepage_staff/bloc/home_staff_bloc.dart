import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:sdeng/model/team.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/repositories/teams_repository.dart';
import 'package:sdeng/util/ui_utils.dart';

part 'home_staff_state.dart';

class HomeStaffBloc extends Cubit<HomeStaffState> {
   HomeStaffBloc() : super(HomeStaffState());

  final TeamsRepository teamsRepository = Get.find();

  Future<void> loadLeagues() async {
    try {
      log('Getting Teams...');
      List<Team> teamsList = await teamsRepository.getTeams();
      log('Teams Getted!');

      emit(state.copyWith(teamsList: teamsList, homeStatus: HomeStatus.loaded));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(homeStatus: HomeStatus.failure));
    }
  }

   Future<void> deleteTeam(String teamId) async {
     try {
       await teamsRepository.deleteTeam(teamId);
     } catch (e) {
       log(e.toString());
       emit(state.copyWith(homeStatus: HomeStatus.failure));
     } finally {
     }
   }
}