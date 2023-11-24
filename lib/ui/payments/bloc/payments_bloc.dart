import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/payment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';

part 'payments_state.dart';

class PaymentsBloc extends Cubit<PaymentsState> {
  PaymentsBloc() : super(PaymentsState());

  final TeamsRepository teamsRepository = GetIt.instance<TeamsRepository>();
  final AthletesRepository athletesRepository = GetIt.instance<AthletesRepository>();
  final StorageRepository storageRepository = GetIt.instance<StorageRepository>();
  final PaymentsRepository paymentsRepository = GetIt.instance<PaymentsRepository>();


  Future<void> load() async {
    try {
      emit(state.copyWith(paymentsStatus: PaymentsStatus.loading));

      log('Loading...');
      List<Athlete> athletes = await athletesRepository.getAllAthletes();
      List<Payment> payments = await paymentsRepository.getAllPayments();
      log('${payments.length} Payments Getted Successfully!');
      log('${athletes.length} Athlete Getted Successfully!');

      emit(state.copyWith(paymentList: payments, athleteList: athletes));

      List<Athlete> okList = [];
      List<Athlete> notPayList = [];
      List<Athlete> partialList = [];

      emit(state.copyWith(paymentsStatus: PaymentsStatus.loading));
      for(Athlete athlete in state.athleteList){
        if(state.paymentList.where((element) => element.athlete == athlete.docId
            && element.amount == athlete.amount).toList().isNotEmpty){
          okList.add(athlete);
        }
        else if(state.paymentList.where((element) => element.athlete == athlete.docId
            && element.amount < athlete.amount).toList().isNotEmpty){
          final list = state.paymentList.where((element) => element.athlete == athlete.docId
            && element.amount < athlete.amount).toList();
          int sum = 0;
          list.forEach((element) => sum += element.amount);
          if(sum == athlete.amount) {
            okList.add(athlete);
          } else {
            partialList.add(athlete);
          }
        }
        else{
          notPayList.add(athlete);
        }
      }
      emit(state.copyWith(okList: okList, notPayList: notPayList, partialList: partialList, paymentsStatus: PaymentsStatus.loaded,));
      log('Payments Calculation complete!');
      log('OK: ${okList.length}');
      log('Partial: ${partialList.length}');
      log('Not Pay: ${notPayList.length}');

    } catch (e) {
      log(e.toString());
    }
  }

}