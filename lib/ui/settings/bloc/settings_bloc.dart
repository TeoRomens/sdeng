import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:sdeng/util/message_util.dart';

part 'settings_state.dart';

class SettingsBloc extends Cubit<SettingsState> {
  SettingsBloc() : super(SettingsState().copyWith(calendarId: Variables.calendarId, biometrics: Variables.biometrics));

  final _authRepository = GetIt.I.get<AuthRepository>();

  Future<void> setBiometrics(bool value) async {
    try{
      emit(state.copyWith(biometrics: value));
      MessageUtil.showLoading();
      await _authRepository.setBiometrics(value);
      log('Biometrics setted to $value');
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(biometrics: !value));
    } finally {
      MessageUtil.hideLoading();
    }
  }

}