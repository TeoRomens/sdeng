import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/model/team.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';

part 'events_state.dart';

class EventsBloc extends Cubit<EventsState> {
  EventsBloc() : super(EventsState());

  final TeamsRepository teamsRepository = GetIt.instance<TeamsRepository>();
  final AthletesRepository athletesRepository = GetIt.instance<AthletesRepository>();
  final StorageRepository storageRepository = GetIt.instance<StorageRepository>();
  final PaymentsRepository paymentsRepository = GetIt.instance<PaymentsRepository>();

  Future<void> loadMedExpires() async {
    try {
      emit(state.copyWith(medExamStatus: MedExamStatus.loading));

      log('Getting Teams...');
      List<Team> teamsList = await teamsRepository.getTeams();
      log('Teams Getted!');

      log('Getting Med Expires...');
      Map<String, int> expiredMap = {};
      Map<String, int> nearExpiredMap = {};
      for(var team in teamsList) {
        final expires = await storageRepository.getExpiresFromTeam(team.docId);
        int expiredCount = 0;
        int nearExpirationCount = 0;
        for (var element in expires) {
          if(DateTime.now().isAfter(element)){
            expiredCount++;
          }else if(DateTime.now().add(const Duration(days: 30)).isAfter(element)){
            nearExpirationCount++;
          }
        }
        expiredMap[team.docId] = expiredCount;
        nearExpiredMap[team.docId] = nearExpirationCount;
      }
      log('Med Expires Getted Successfully!');

      emit(state.copyWith(teamsList: teamsList, medExamExpiredMap: expiredMap, medExamNearExpireMap: nearExpiredMap, medExamStatus: MedExamStatus.loaded));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(medExamStatus: MedExamStatus.failure));
    }
  }

  Future<void> loadPaymentExpires() async {
    try {
      emit(state.copyWith(paymentsStatus: PaymentsStatus.loading));

      log('Getting Payments Expires...');
      List<Payment> expired = await paymentsRepository.getExpiredPayments();
      log('Payments Expires Getted Successfully!');

      int totalAthletes = await athletesRepository.getNumAthletes();
      int numPrimaRataPaid = await paymentsRepository.getNumPrimaRataPaid();
      int numSecRataPaid = await paymentsRepository.getNumSecRataPaid();
      int numRataUnPaid = await paymentsRepository.getNumRataUnPaid();
      int cashed = await paymentsRepository.getAlreadyCashed();
      int cashLeft = await paymentsRepository.getCashLeft();

      emit(state.copyWith(
        paymentExpiredList: expired,
        paymentsStatus: PaymentsStatus.loaded,
        numRataUnPaid: numRataUnPaid,
        numPrimaRataPaid: numPrimaRataPaid,
        numSecRataPaid: numSecRataPaid,
        totalAthletes: totalAthletes,
        cashed: cashed,
        cashLeft: cashLeft
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(medExamStatus: MedExamStatus.failure));
    }
  }
}