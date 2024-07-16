import 'package:formz/formz.dart';

/// Non-empty Form Input Validation Error
enum NonEmptyValidationError {
  /// Field is empty
  empty
}

/// {@template non_empty}
/// Reusable non-empty form input.
/// {@endtemplate}
class NonEmpty extends FormzInput<String, NonEmptyValidationError> {
  /// {@macro non_empty}
  const NonEmpty.pure() : super.pure('');

  /// {@macro non_empty}
  NonEmpty.dirty([String value = '']) : super.dirty(value.trim());

  @override
  NonEmptyValidationError? validator(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return NonEmptyValidationError.empty;
    }

    return null;
  }
}

/// {@template non_empty}
/// Return a string text from [NonEmptyValidationError] object.
/// {@endtemplate}
extension NonemptyErrorText on NonEmptyValidationError {
  /// Method
  String get text {
    switch (this) {
      case NonEmptyValidationError.empty:
        return 'This field cannot be empty';
    }
  }
}
