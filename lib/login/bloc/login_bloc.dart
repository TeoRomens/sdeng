import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'login_state.dart';

/// The BLoC for managing the login process.
///
/// This BLoC handles the following login actions:
/// - Google authentication
/// - Credential-based login (email and password)
/// - Password recovery (forgot password)
///
/// It maintains the state of the login process using [LoginState] and emits updates
/// based on the progress and outcome of login actions.
class LoginBloc extends Cubit<LoginState> {
  /// Creates an instance of [LoginBloc].
  ///
  /// Requires a [UserRepository] to perform authentication operations.
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState());

  final UserRepository _userRepository;

  /// Initiates the Google login process.
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while the request is in progress,
  /// [FormzSubmissionStatus.success] if the login is successful,
  /// [FormzSubmissionStatus.canceled] if the login is canceled,
  /// and [FormzSubmissionStatus.failure] if an error occurs.
  Future<void> googleSubmitted() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

  /// Initiates the login process with email and password.
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while the request is in progress,
  /// [FormzSubmissionStatus.success] if the login is successful,
  /// and [FormzSubmissionStatus.failure] if an error occurs.
  /// The error message is set to 'Authentication error' in case of failure.
  Future<void> loginWithCredentials({
    required Email email,
    required Password password,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithCredentials(
          email: email.value, password: password.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          error: 'Authentication error'));
      addError(error, stackTrace);
    }
  }

  /// Initiates the password recovery process.
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while the request is in progress,
  /// [FormzSubmissionStatus.success] if the password recovery is successful,
  /// and [FormzSubmissionStatus.failure] if an error occurs.
  Future<void> forgotPassword({
    required Email email,
  }) async {
    if (!Formz.validate([email])) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.forgotPassword(email: email.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
