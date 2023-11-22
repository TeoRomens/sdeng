import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginState());

  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void rememberme(bool rememberme) {
    emit(state.copyWith(rememberme: rememberme));
  }

  Future<void> login([LoginProvider? provider]) async {
    final String message;
    final User? user;
    emit(state.copyWith(loginStatus: LoginStatus.submitting));
    try {
      log('Trying to login...');
      switch (provider) {
        case LoginProvider.google: {
          user = await _authRepository.signInWithGoogle();
          break;
        }
        case LoginProvider.biometrics: {
          user = await _authRepository.authenticateWithBiometrics();
        }
        break;
        default:
          user = await _authRepository.login(state.email, state.password);
      }
      if(user != null){
        log('Login Success!');
        if(await _authRepository.checkUserInDatabase(user.uid)){
          await writeCredentials();
          if(await _authRepository.isStaff(user.uid)) {
            await _authRepository.loadVariables(user.uid);
            emit(state.copyWith(loginStatus: LoginStatus.successStaff));
          } else {
            emit(state.copyWith(loginStatus: LoginStatus.successAthlete));
          }
        } else {
          _authRepository.deleteCurrentUser();
          emit(state.copyWith(loginStatus: LoginStatus.failure, errorMessage: 'User not found, please sign up before logging in'));
          emit(state.copyWith(loginStatus: LoginStatus.idle));
        }
      } else {
        throw Exception('Error during login');
      }
    } on FirebaseAuthException catch (e){
      switch(e.code){
        case 'invalid-email': message = 'Invalid Email';
        break;
        case 'user-disabled': message = 'User Disabled, contact the administrator to solve the issue';
        break;
        case 'user-not-found': message = 'User not found, please sign up before logging in';
        break;
        case 'wrong-password': message = 'Wrong password, retry';
        break;
        case 'missing-provider': message = 'You can link your google account in settings';
        break;
        default: message = 'Unknown Error';
      }
      emit(state.copyWith(errorMessage: message, loginStatus: LoginStatus.failure));
      emit(state.copyWith(loginStatus: LoginStatus.idle));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), loginStatus: LoginStatus.failure));
      emit(state.copyWith(loginStatus: LoginStatus.idle));
    }
  }

  Future<void> writeCredentials() async {
    _authRepository.writeCredentials(
        email: state.email,
        password: state.password,
        rememberme: state.rememberme
    );
  }

  Future<void> checkSavedCredentials() async {
    log("Checking saved Credentials...");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool rememberme = prefs.getBool("remember_me") ?? false;
      if (rememberme) {
        String email = prefs.getString("email") ?? "";
        String password = prefs.getString("password") ?? "";
        log('Found saved credentials');
        emit(state.copyWith(email: email, password: password, rememberme: rememberme, loginStatus: LoginStatus.submitting));
        login(LoginProvider.password);
      }
      else{
        log('No saved credentials found');
        emit(state.copyWith(loginStatus: LoginStatus.idle));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(loginStatus: LoginStatus.failure));
      emit(state.copyWith(loginStatus: LoginStatus.idle));
    }
  }

  Future<void> checkBiometrics() async {
    log("Checking biometrics...");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool biometrics = prefs.getBool("biometrics") ?? false;
      if (biometrics) {
        login(LoginProvider.biometrics);
      }
      else{
        log('No biometrics found');
        emit(state.copyWith(loginStatus: LoginStatus.idle));
      }
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(loginStatus: LoginStatus.failure));
      emit(state.copyWith(loginStatus: LoginStatus.idle));
    }
  }

}
