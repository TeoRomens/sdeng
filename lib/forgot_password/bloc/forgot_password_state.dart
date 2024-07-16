part of 'forgot_password_bloc.dart';

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final Email email;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props => [email, status, error];

  ForgotPasswordState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      error: error ?? this.error
    );
  }
}
