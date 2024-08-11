import 'package:formz/formz.dart';

/// Date Form Input Validation Error
enum DateValidationError {
  /// Date is invalid
  invalidFormat,

  /// Date is empty
  empty
}

/// {@template date}
/// Reusable date form input.
/// {@endtemplate}
class Date extends FormzInput<String, DateValidationError> {
  /// {@macro date}
  const Date.pure() : super.pure('');

  /// {@macro date}
  const Date.dirty([super.value = '']) : super.dirty();

  @override
  DateValidationError? validator(String value) {
    if (value.isEmpty) {
      return DateValidationError.empty;
    }

    final dateParts = value.split('/');
    if (dateParts.length != 3 ||
        dateParts[0].length != 2 ||
        dateParts[1].length != 2 ||
        dateParts[2].length != 4) {
      return DateValidationError.invalidFormat;
    }

    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) {
      return DateValidationError.invalidFormat;
    }

    if (day < 1 || day > 31 || month < 1 || month > 12) {
      return DateValidationError.invalidFormat;
    }

    return null;
  }
}

/// {@template date}
/// Return a string text from [DateValidationError] object.
/// {@endtemplate}
extension DateErrorText on DateValidationError {
  /// Method
  String get text {
    switch (this) {
      case DateValidationError.invalidFormat:
        return 'Please enter a valid date in the format DD/MM/YYYY';
      case DateValidationError.empty:
        return 'Please enter a date';
    }
  }
}
