part of 'login_bloc.dart';

/// The state for the [LoginBloc], representing the current status of the login form.
///
/// This class holds the following properties:
/// - [email]: Represents the email input field, using the [Email] form input.
/// - [password]: Represents the password input field, using the [Password] form input.
/// - [status]: Represents the submission status of the form, using [FormzSubmissionStatus].
/// - [error]: A string to hold any error messages related to login attempts.
class LoginState extends Equatable {
  /// Creates a new instance of [LoginState].
  ///
  /// By default, all fields are initialized to their pure form or initial state.
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The email input field.
  final Email email;

  /// The password input field.
  final Password password;

  /// The submission status of the form.
  final FormzSubmissionStatus status;

  /// A string to hold any error messages.
  final String error;

  @override
  List<Object> get props => [email, password, status, error];

  /// Creates a copy of this [LoginState] with optional new values.
  ///
  /// This method allows you to create a new [LoginState] instance with
  /// updated values while preserving the original state values.
  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        error: error ?? this.error);
  }
}
