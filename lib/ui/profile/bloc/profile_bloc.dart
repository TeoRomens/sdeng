import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/instance_manager.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:sdeng/util/ui_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc() : super(ProfileState());

  final _authRepository = Get.find<AuthRepository>();

  Future<void> linkGoogleAccount() async {
    try{
      await _authRepository.linkGoogleAccount();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'provider-already-linked': UIUtils.showMessage('Google is already linked');
        break;
      }
    } finally {
    }
  }

  void selectMenu(SelectedMenu selectedMenu) {
    emit(state.copyWith(selectedMenu: selectedMenu));
  }

  Future<void> logout() async {
    try {
      log('Trying to Logout');
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool("remember_me", false);
        prefs.setString('email', "");
        prefs.setString('password', "");
      });
      await _authRepository.logout();
      log('Logout Success!');

    } catch (e) {
      log(e.toString());
    }
  }

}