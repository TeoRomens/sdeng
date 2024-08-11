import 'package:formz/formz.dart';

/// Phone Number Form Input Validation Error
enum PhoneNumberValidationError {
  /// Phone number is invalid (generic validation error)
  invalid,

  /// Phone number is empty
  empty
}

/// {@template phone_number}
/// Reusable phone number form input.
/// {@endtemplate}
class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  /// {@macro phone_number}
  const PhoneNumber.pure() : super.pure('');

  /// {@macro phone_number}
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneNumberRegExp = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  @override
  PhoneNumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return PhoneNumberValidationError.empty;
    } else if (!_phoneNumberRegExp.hasMatch(value)) {
      return PhoneNumberValidationError.invalid;
    }

    return null;
  }
}

/// {@template phone_number}
/// Return a string text from [PhoneNumberValidationError] object.
/// {@endtemplate}
extension PhoneNumberErrorText on PhoneNumberValidationError {
  /// Method
  String get text {
    switch (this) {
      case PhoneNumberValidationError.invalid:
        return 'Please ensure the phone number entered is valid';
      case PhoneNumberValidationError.empty:
        return 'Please enter a phone number';
    }
  }
}
