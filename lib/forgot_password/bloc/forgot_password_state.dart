part of 'forgot_password_bloc.dart';

/// Represents the state of the forgot password feature.
///
/// This state includes the current email input, the status of the password
/// reset request, and any error messages that may have occurred.
class ForgotPasswordState extends Equatable {
  /// Creates a [ForgotPasswordState] with optional parameters.
  ///
  /// - [email]: The email address provided for the password reset request.
  /// - [status]: The current submission status of the password reset request.
  /// - [error]: Any error message related to the password reset request.
  const ForgotPasswordState({
    this.email = const Email.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The email address provided by the user for the password reset request.
  final Email email;

  /// The current status of the password reset request.
  final FormzSubmissionStatus status;

  /// Any error message that may have occurred during the password reset request.
  final String error;

  @override
  List<Object> get props => [email, status, error];

  /// Returns a new instance of [ForgotPasswordState] with updated properties.
  ///
  /// - [email]: The new email address to set (optional).
  /// - [status]: The new submission status to set (optional).
  /// - [error]: The new error message to set (optional).
  ForgotPasswordState copyWith({
    Email? email,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
