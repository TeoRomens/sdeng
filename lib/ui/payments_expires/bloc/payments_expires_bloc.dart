import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';

part 'payments_expires_state.dart';

class PayExpiresBloc extends Cubit<PayExpiresState> {
  PayExpiresBloc() : super(PayExpiresState());

  final AthletesRepository athletesRepository = GetIt.instance<AthletesRepository>();
  final PaymentsRepository paymentsRepository = GetIt.instance<PaymentsRepository>();

  Future<void> load(List<Payment> paymentsList) async {
    try {
      emit(state.copyWith(paymentsList: paymentsList, status: Status.loading,));

      log('Getting Athletes...');
      List<Athlete> athletesList = [];
      for(var element in paymentsList){
        await athletesRepository.getAthlete(element.athlete).then((value) => athletesList.add(value!));
      }
      log('Athletes Getted');

      emit(state.copyWith(athletesList: athletesList, status: Status.loaded));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(status: Status.failure));
    }
  }

}