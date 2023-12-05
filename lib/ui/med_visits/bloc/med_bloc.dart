import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/med_visit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';

part 'med_state.dart';

class MedBloc extends Cubit<MedState> {
  MedBloc() : super(MedState());

  final TeamsRepository teamsRepository = Get.find();
  final AthletesRepository athletesRepository = Get.find();
  final StorageRepository storageRepository = Get.find();

  Future<void> load() async {
    try {
      emit(state.copyWith(medStatus: MedStatus.loading));

      log('Loading...');
      List<Athlete> athletes = await athletesRepository.getAllAthletes();
      log('${athletes.length} Athlete Getted Successfully!');

      List<Athlete> unknown = [];
      List<Athlete> expired = [];
      List<Athlete> near = [];

      for(Athlete athlete in athletes){
        MedVisit? medVisit = await storageRepository.getExpire(athlete);
        if(medVisit == null) {
          unknown.add(athlete);
        }
        else {
          if(DateTime.now().isAfter(medVisit.expiringDate)){
            expired.add(athlete);
          }
          else if(DateTime.now().add(const Duration(days: 15)).isAfter(medVisit.expiringDate)){
            near.add(athlete);
          }
        }
      }

      emit(state.copyWith(expiredList: expired, nearExpiredList: near, unknownList: unknown, medStatus: MedStatus.loaded));
    } catch (e) {
      log(e.toString());
    }
  }

}