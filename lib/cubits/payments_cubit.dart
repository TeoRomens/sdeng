import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/repository.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit({required Repository repository})
      : _repository = repository,
        super(PaymentsInitial());

  final Repository _repository;

  /// List of payments cache in memory
  List<Payment> _payments = <Payment>[];

  Future<void> loadPaymentFromId(String id) async {
    emit(PaymentsLoading());
    final paymentList = await _repository.loadPaymentsFromAthleteId(id);
    _payments.addAll(paymentList);
    emit(PaymentsLoaded(payments: _payments));
  }

  Future<void> getAllPayments() async {
    emit(PaymentsLoading());
    final payments = await _repository.loadPayments();
    emit(PaymentsLoaded(payments: payments));
  }

  Future<void> addPayment({
    required String athleteId,
    required String cause,
    required int amount,
    required PaymentType paymentType,
    required PaymentMethod paymentMethod,
  }) async {
    try{
      emit(PaymentsLoading());
      final payment = await _repository.addPayment(
          cause: cause,
          amount: amount,
          paymentType: paymentType,
          paymentMethod: paymentMethod,
          athleteId: athleteId
      );
      _payments.add(payment);
      emit(PaymentsLoaded(payments: _payments));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadPaymentsFromAthleteId(String athleteId) async {
    try{
      emit(PaymentsLoading());
      final payments = await _repository.loadPaymentsFromAthleteId(athleteId);
      _payments = payments;
      emit(PaymentsLoaded(payments: _payments));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadPayments() async {
    try{
      emit(PaymentsLoading());
      final payments = await _repository.loadPayments();
      _payments = payments;
      emit(PaymentsLoaded(payments: _payments));
    } catch (e) {
      log(e.toString());
    }
  }

  double getTotal() {
    double sum = 0;
    for(final payment in _payments){
      sum += payment.amount;
    }
    return sum;
  }
}