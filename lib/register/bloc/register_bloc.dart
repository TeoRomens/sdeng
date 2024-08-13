import 'dart:async';

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'register_state.dart';

/// Manages the registration process, including handling user login and signup.
class RegisterBloc extends Cubit<RegisterState> {
  /// Creates a [RegisterBloc] instance with the required [userRepository].
  ///
  /// - [userRepository]: The repository used for user authentication and registration.
  RegisterBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const RegisterState());

  final UserRepository _userRepository;

  /// Handles the submission of a Google login request.
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while the login is being processed.
  /// On success, emits [FormzSubmissionStatus.success].
  /// On cancellation, emits [FormzSubmissionStatus.canceled].
  /// On failure, emits [FormzSubmissionStatus.failure] and logs the error.
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

  /// Handles the submission of user signup credentials.
  ///
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while the signup is being processed.
  /// If the email is invalid, emits [FormzSubmissionStatus.failure] without attempting signup.
  /// On success, emits [FormzSubmissionStatus.success].
  /// On failure, emits [FormzSubmissionStatus.failure] and logs the error.
  Future<void> signupWithCredentials({
    required Email email,
    required Password password,
  }) async {
    if (!Formz.validate([email])) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
      ));
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.signUpWithCredentials(
        email: email.value,
        password: password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
