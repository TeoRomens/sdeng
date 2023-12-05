import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:sdeng/util/ui_utils.dart';

part 'settings_state.dart';

class SettingsBloc extends Cubit<SettingsState> {
  SettingsBloc() : super(SettingsState().copyWith(calendarId: Variables.calendarId, biometrics: Variables.biometrics));

  final AuthRepository _authRepository = Get.find();

  Future<void> setBiometrics(bool value) async {
    try{
      emit(state.copyWith(biometrics: value));
      if(value){
        await _authRepository.checkBiometrics();
      }
      await _authRepository.setBiometrics(value);
      log('Biometrics set to $value');
    } catch (e) {
      log(e.toString());
      UIUtils.showError('Error using biometrics');
      emit(state.copyWith(biometrics: !value));
    }
  }

  Future<void> payDate1Changed(DateTime selectedDate) async {
    try{
      await _authRepository.setPayDate1(selectedDate);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> payDate2Changed(DateTime selectedDate) async {
    try{
      await _authRepository.setPayDate2(selectedDate);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> quotaMBChanged(int value) async {
    try{
      await _authRepository.setQuotaMB(value);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> quotaUnderChanged(int value) async {
    try{
      await _authRepository.setQuotaUnder(value);
    } catch (e) {
      log(e.toString());
    }
  }

}