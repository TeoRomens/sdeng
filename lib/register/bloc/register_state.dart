part of 'register_bloc.dart';

/// Represents the state of the registration form.
///
/// This state holds the current values of the email and password fields,
/// the form submission status, the validity of the form, and any error messages.
class RegisterState extends Equatable {
  /// Creates a [RegisterState] instance with the given parameters.
  ///
  /// Defaults to:
  /// - [email]: An unvalidated email.
  /// - [password]: An unvalidated password.
  /// - [status]: The initial form submission status.
  /// - [valid]: A boolean indicating whether the form is valid.
  /// - [error]: A string holding any error message related to the signup process.
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.valid = false,
    this.error = 'Signup error',
  });

  /// The current email value.
  final Email email;

  /// The current password value.
  final Password password;

  /// The current status of form submission.
  final FormzSubmissionStatus status;

  /// A boolean indicating whether the form is valid.
  final bool valid;

  /// Any error message related to the signup process.
  final String error;

  @override
  List<Object> get props => [email, status, valid, error];

  /// Creates a copy of this [RegisterState] with the given parameters.
  ///
  /// If a parameter is not provided, it defaults to the current value of that parameter.
  ///
  /// - [email]: The email value to use in the new state.
  /// - [password]: The password value to use in the new state.
  /// - [status]: The form submission status to use in the new state.
  /// - [valid]: The validity of the form to use in the new state.
  /// - [error]: The error message to use in the new state.
  ///
  /// Returns a new [RegisterState] with the updated values.
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
