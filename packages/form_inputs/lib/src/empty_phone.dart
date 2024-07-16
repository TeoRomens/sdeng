import 'package:formz/formz.dart';

/// Phone Number Form Input Validation Error
enum EmptyPhoneNumberValidationError {
  /// Phone number is invalid (generic validation error)
  invalid,
}

/// {@template phone_number}
/// Reusable phone number form input.
/// {@endtemplate}
class EmptyPhoneNumber extends FormzInput<String, EmptyPhoneNumberValidationError> {
  /// {@macro phone_number}
  const EmptyPhoneNumber.pure() : super.pure('');

  /// {@macro phone_number}
  const EmptyPhoneNumber.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneNumberRegExp = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  @override
  EmptyPhoneNumberValidationError? validator(String value) {
    if(value.isEmpty) return null;

    if (!_phoneNumberRegExp.hasMatch(value)) {
      return EmptyPhoneNumberValidationError.invalid;
    }

    return null;
  }
}

/// {@template phone_number}
/// Return a string text from [EmptyPhoneNumberValidationError] object.
/// {@endtemplate}
extension EmptyPhoneNumberErrorText on EmptyPhoneNumberValidationError {
  /// Method
  String get text {
    switch (this) {
      case EmptyPhoneNumberValidationError.invalid:
        return 'Please ensure the phone number entered is valid';
    }
  }
}
