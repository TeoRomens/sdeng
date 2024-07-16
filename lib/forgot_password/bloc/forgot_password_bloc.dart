import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Cubit<ForgotPasswordState> {
  ForgotPasswordBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ForgotPasswordState());

  final UserRepository _userRepository;

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
