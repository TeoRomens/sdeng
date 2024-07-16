import 'package:formz/formz.dart';

/// Italian Tax Code Form Input Validation Error
enum ItalianTaxCodeValidationError {
  /// Tax code is invalid
  invalid,
  /// Tax code is empty
  empty
}

/// {@template italian_tax_code}
/// Reusable Italian tax code form input.
/// {@endtemplate}
class TaxCode extends FormzInput<String, ItalianTaxCodeValidationError> {
  /// {@macro italian_tax_code}
  const TaxCode.pure() : super.pure('');

  /// {@macro italian_tax_code}
  const TaxCode.dirty([super.value = '']) : super.dirty();

  static final RegExp _taxCodeRegExp = RegExp(
    r'^[A-Za-z]{6}\d{2}[A-Za-z]\d{2}[A-Za-z]\d{3}[A-Za-z]$',
  );

  @override
  ItalianTaxCodeValidationError? validator(String value) {
    if (value.isEmpty) {
      return ItalianTaxCodeValidationError.empty;
    } else if (!_taxCodeRegExp.hasMatch(value)) {
      return ItalianTaxCodeValidationError.invalid;
    }

    return null;
  }
}

/// {@template italian_tax_code}
/// Return a string text from [ItalianTaxCodeValidationError] object.
/// {@endtemplate}
extension TaxcodeErrorText on ItalianTaxCodeValidationError {
  /// Method
  String get text {
    switch (this) {
      case ItalianTaxCodeValidationError.invalid:
        return 'Please ensure the tax code entered is valid';
      case ItalianTaxCodeValidationError.empty:
        return 'This field cannot be empty';
    }
  }
}
