import 'package:formz/formz.dart';

/// Date Form Input Validation Error
enum EmptyDateValidationError {
  /// Date is invalid
  invalidFormat,
}

/// {@template date}
/// Reusable date form input.
/// {@endtemplate}
class EmptyDate extends FormzInput<String, EmptyDateValidationError> {
  /// {@macro date}
  const EmptyDate.pure() : super.pure('');

  /// {@macro date}
  const EmptyDate.dirty([super.value = '']) : super.dirty();

  @override
  EmptyDateValidationError? validator(String value) {
    if (value.isEmpty) return null;

    final dateParts = value.split('/');
    if (dateParts.length != 3 ||
        dateParts[0].length != 2 ||
        dateParts[1].length != 2 ||
        dateParts[2].length != 4) {
      return EmptyDateValidationError.invalidFormat;
    }

    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) {
      return EmptyDateValidationError.invalidFormat;
    }

    if (day < 1 || day > 31 || month < 1 || month > 12) {
      return EmptyDateValidationError.invalidFormat;
    }

    return null;
  }
}

/// {@template date}
/// Return a string text from [EmptyDateValidationError] object.
/// {@endtemplate}
extension EmptyDateErrorText on EmptyDateValidationError {
  /// Method
  String get text {
    switch (this) {
      case EmptyDateValidationError.invalidFormat:
        return 'Please enter a valid date in the format DD/MM/YYYY';
    }
  }
}
