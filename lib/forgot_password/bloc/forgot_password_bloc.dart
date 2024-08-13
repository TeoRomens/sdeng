import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'forgot_password_state.dart';

/// Bloc responsible for managing the state of the "forgot password" feature.
///
/// This bloc handles the process of requesting a password reset by validating
/// the provided email and calling the corresponding method in the [UserRepository].
class ForgotPasswordBloc extends Cubit<ForgotPasswordState> {
  /// Creates a [ForgotPasswordBloc] with the given [UserRepository].
  ///
  /// The [UserRepository] is used to handle the backend logic for password
  /// reset requests.
  ForgotPasswordBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ForgotPasswordState());

  final UserRepository _userRepository;

  /// Initiates a password reset request for the given email.
  ///
  /// The method validates the provided [email] and updates the bloc state
  /// to reflect the current status of the request. It emits an [inProgress]
  /// state while the request is being processed, a [success] state upon
  /// successful completion, and a [failure] state if an error occurs.
  ///
  /// [email] is required and must be a valid email address.
  Future<void> forgotPassword({
    required Email email,
  }) async {
    // Validate the email input
    if (!Formz.validate([email])) return;

    // Emit inProgress state while the request is being processed
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      // Attempt to initiate a password reset request
      await _userRepository.forgotPassword(email: email.value);
      // Emit success state if the request completes successfully
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      // Emit failure state if an error occurs
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}
