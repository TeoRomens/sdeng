part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.valid = false,
    this.error = 'Signup error'
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool valid;
  final String error;

  @override
  List<Object> get props => [email, status, valid, error];

  RegisterState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? valid,
    String? error,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      error: error ?? this.error,
    );
  }
}
