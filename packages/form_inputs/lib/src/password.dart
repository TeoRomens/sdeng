import 'package:formz/formz.dart';

/// Password Form Input Validation Error
enum PasswordValidationError {
  /// Password is too short
  tooShort,
  /// Password is too weak
  weak,
  /// Password is empty
  empty
}

/// {@template password}
/// Reusable password form input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.tooShort;
    } else if (!_passwordRegExp.hasMatch(value)) {
      return PasswordValidationError.weak;
    }

    return null;
  }
}

/// {@template password}
/// Return a string text from [PasswordValidationError] object.
/// {@endtemplate}
extension PasswordErrorText on PasswordValidationError {
  /// Method
  String get text {
    switch (this) {
      case PasswordValidationError.tooShort:
        return 'Password must be at least 8 characters long';
      case PasswordValidationError.weak:
        return 'Password must contain both letters and numbers';
      case PasswordValidationError.empty:
        return 'Please enter a password';
    }
  }
}
