import 'package:formz/formz.dart';

/// Email Form Input Validation Error
enum EmptyEmailValidationError {
  /// Email is invalid (generic validation error)
  invalid,
}

/// {@template email}
/// Reusable email form input.
/// {@endtemplate}
class EmptyEmail extends FormzInput<String, EmptyEmailValidationError> {
  /// {@macro email}
  const EmptyEmail.pure() : super.pure('');

  /// {@macro email}
  const EmptyEmail.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  @override
  EmptyEmailValidationError? validator(String value) {
    if(value.isEmpty) return null;

    if (!_emailRegExp.hasMatch(value)) {
      return EmptyEmailValidationError.invalid;
    }
    return null;
  }

}

/// {@template email}
/// Return a string text from [EmptyEmailValidationError] object.
/// {@endtemplate}
extension EmptyEmailErrorText on EmptyEmailValidationError {
  /// Method
  String get text {
    switch (this) {
      case EmptyEmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
    }
  }
}
