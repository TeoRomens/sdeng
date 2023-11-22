import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/parents_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';

part 'team_details_state.dart';

class TeamDetailsBloc extends Cubit<TeamDetailsState> {
  TeamDetailsBloc() : super(TeamDetailsState());

  final AthletesRepository athletesRepository = GetIt.instance<AthletesRepository>();
  final TeamsRepository teamsRepository = GetIt.instance<TeamsRepository>();
  final PaymentsRepository paymentsRepository = GetIt.instance<PaymentsRepository>();
  final ParentsRepository parentsRepository = GetIt.instance<ParentsRepository>();

  Future<void> loadAthletes(String teamId, [Source? source]) async {
    try {
      emit(state.copyWith(pageStatus: TeamDetailsPageStatus.loading));
      log('Getting Athletes...');
      List<Athlete> athletesList = await athletesRepository.getAthletesFromTeam(teamId);
      log('Athletes Getted');
      log('Calculating Values...');
      int earnings = await athletesRepository.getEarnings(teamId);
      int cashLeft = await athletesRepository.getRemainingCash(teamId);
      log('Calculation Complete');

      emit(state.copyWith(athletesList: athletesList, earnings: earnings, cashLeft: cashLeft, pageStatus: TeamDetailsPageStatus.loaded));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(pageStatus: TeamDetailsPageStatus.failure));
    }
  }

  Future<void> deleteAthlete(Athlete athlete) async {
    try {
      await teamsRepository.removeAthlete(athlete.teamId, athlete.docId);
      await paymentsRepository.removePayment(athlete.paymentId);
      await parentsRepository.removeParent(athlete.parentId);
      await athletesRepository.deleteAthlete(athlete.docId);

      log('Athlete ${athlete.docId} deleted!');

    } catch (e) {
      log(e.toString());
      emit(state.copyWith(pageStatus: TeamDetailsPageStatus.failure));
    }
  }

  searchChangedEventHandler(String search) async {
    emit(state.copyWith(search: search));
  }

  selectAthlete(Athlete athlete){
    emit(state.copyWith(selectedAthlete: athlete));
  }

}