import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavBarBloc {
  BottomNavBarBloc();

  final _userRepo = GetIt.instance<AuthRepository>();

  Future<void> logout() async {
    try {
      log('Trying to Logout');
      await SharedPreferences.getInstance().then((prefs) {
        prefs.setBool("remember_me", false);
        prefs.setString('email', "");
        prefs.setString('password', "");
      });
      await _userRepo.logout();
      log('Logout Success!');

    } catch (e) {
      log(e.toString());
    }
  }
}