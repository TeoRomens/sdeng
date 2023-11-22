part of 'login_bloc.dart';

enum LoginStatus {
  successAthlete,
  successStaff,
  failure,
  submitting,
  idle,
}

enum LoginProvider{
  google,
  password,
  biometrics,
}

class LoginState {
  LoginState({
    this.email = '',
    this.password = '',
    this.rememberme = false,
    this.errorMessage = '',
    this.loginStatus = LoginStatus.idle,
  });

  final String email;
  final String password;
  final bool rememberme;
  final String errorMessage;
  final LoginStatus loginStatus;

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberme,
    String? errorMessage,
    LoginStatus? loginStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberme: rememberme ?? this.rememberme,
      errorMessage: errorMessage ?? this.errorMessage,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}
