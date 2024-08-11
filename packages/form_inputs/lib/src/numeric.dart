import 'package:formz/formz.dart';

/// Positive Numeric Form Input Validation Error
enum NumericValidationError {
  /// Value is empty
  empty,

  /// Value is not a valid number
  invalid,
}

/// {@template positive_numeric}
/// Reusable positive numeric form input.
/// {@endtemplate}
class Numeric extends FormzInput<String, NumericValidationError> {
  /// {@macro positive_numeric}
  const Numeric.pure() : super.pure('');

  /// {@macro positive_numeric}
  const Numeric.dirty([super.value = '']) : super.dirty();

  @override
  NumericValidationError? validator(String value) {
    if (value.isEmpty) {
      return NumericValidationError.empty;
    }

    final numericValue = num.tryParse(value);
    if (numericValue == null) {
      return NumericValidationError.invalid;
    }

    return null;
  }
}

/// {@template positive_numeric}
/// Return a string text from [PositiveNumericValidationError] object.
/// {@endtemplate}
extension NumericErrorText on NumericValidationError {
  /// Method
  String get text {
    switch (this) {
      case NumericValidationError.empty:
        return 'Please enter a number';
      case NumericValidationError.invalid:
        return 'Please enter a valid number';
    }
  }
}
