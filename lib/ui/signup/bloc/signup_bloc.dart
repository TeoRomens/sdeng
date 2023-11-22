import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/model/staff_member.dart';
import 'package:sdeng/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupBloc extends Cubit<SignupState> {
  SignupBloc() : super(SignupState());
  
  final AuthRepository _userRepository = GetIt.instance<AuthRepository>();

  signupNameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  signupSurnameChanged(String surname) {
    emit(state.copyWith(surname: surname));
  }

  signupEmailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  signupConfirmEmailChanged(String confirmEmail) {
    emit(state.copyWith(confirmEmail: confirmEmail));
  }

  signupPasswordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  signupConfirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  signupSocietyNameChanged(String societyName) {
    emit(state.copyWith(societyName: societyName));
  }

  signupSocietyTaxIdChanged(String societyTaxId) {
    emit(state.copyWith(societyTaxId: societyTaxId));
  }

  signupSocietyPivaChanged(String societyPiva) {
    emit(state.copyWith(societyPiva: societyPiva));
  }

  signupSocietyEmailChanged(String societyEmail) {
    emit(state.copyWith(societyEmail: societyEmail));
  }

  signupSocietyFipCodeChanged(String societyFipCode) {
    emit(state.copyWith(societyFipCode: societyFipCode));
  }

  signupSocietyAddressChanged(String societyAddress) {
    emit(state.copyWith(societyAddress: societyAddress));
  }

  signupSocietyCityChanged(String societyCity) {
    emit(state.copyWith(societyCity: societyCity));
  }

  signupSocietyCAPChanged(String societyCAP) {
    emit(state.copyWith(societyCap: societyCAP));
  }

  signupSocietyPayDate1Changed(DateTime date) {
    emit(state.copyWith(closingPayDate1: date));
  }

  signupSocietyPayDate2Changed(DateTime date) {
    emit(state.copyWith(closingPayDate2: date));
  }

  signupSocietyAmountUnderChanged(int amount) {
    emit(state.copyWith(totalAmountUnder: amount));
  }

  signupSocietyAmountMBChanged(int amount) {
    emit(state.copyWith(totalAmountMB: amount));
  }

  signupPlanChanged(SubscriptionPlan plan) {
    emit(state.copyWith(plan: plan));
  }

  Future<void> createAccount() async {
    try {
      emit(state.copyWith(signupStatus: SignupStatus.submitting));
      StaffMember staffMember = StaffMember(
        name: state.name,
        surname: state.surname,
        email: state.email,
        id: '',
        societyName: state.societyName,
        societyEmail: state.societyEmail,
        societyAddress: state.societyAddress,
        societyCity: state.societyCity,
        societyCap: state.societyCap,
        societyTaxId: state.societyTaxId,
        societyFipCode: state.societyFipCode,
        societyPIva: state.societyPiva,
        closingPayDate1: state.closingPayDate1,
        closingPayDate2: state.closingPayDate2,
        totalAmountUnder: state.totalAmountUnder,
        totalAmountMB: state.totalAmountMB
      );

      final user = await _userRepository.signupStaff(state.email, state.password, staffMember);

      if (user != null) {
        await _userRepository.loadVariables(user.uid);
      } else {
        throw Exception('User equals to null');
      }
      emit(state.copyWith(signupStatus: SignupStatus.success));

    } catch (e) {
      emit(state.copyWith(signupStatus: SignupStatus.failure, errorMessage: e.toString()));
      emit(state.copyWith(signupStatus: SignupStatus.idle));
    }
  }

  nextStep(){
    emit(state.copyWith(signupStep: SignupStep.values.elementAt(state.signupStep.index + 1)));
  }

  logState() {
    log(
        'SignupState\n'
        'name: ${state.name}\n'
        'surname: ${state.surname}\n'
        'email: ${state.email}\n'
        'societyName: ${state.societyName}\n'
        'societyEmail: ${state.societyEmail}\n'
        'societyAddress: ${state.societyAddress}\n'
        'societyCity: ${state.societyCity}\n'
        'societyCap: ${state.societyCap}\n'
        'societyPiva: ${state.societyPiva}\n'
        'societyFipCode: ${state.societyFipCode}\n'
        '${state.societyTaxId}\n'
        '${state.totalAmountMB}\n'
        '${state.totalAmountUnder}\n'
        '${state.closingPayDate1}\n'
        '${state.closingPayDate2}\n'
    );
  }
}