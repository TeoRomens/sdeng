import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:sdeng/model/staff_member.dart';
import 'package:sdeng/repositories/auth_repository.dart';

part 'signup_state.dart';

class SignupBloc extends Cubit<SignupState> {
  SignupBloc() : super(SignupState());
  
  final AuthRepository _userRepository = Get.find();

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
        closingPayDate1: null,
        closingPayDate2: null,
        totalAmountUnder: null,
        totalAmountMB: null
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
}