part of 'add_payment_cubit.dart';

/// A state class for managing the state of adding a payment.
///
/// This class extends [Equatable] to allow for easy comparison and
/// immutability of the state. It includes properties for managing
/// the payment formula, athlete, cause, amount, date, status, and any
/// error messages.
///
/// All properties are immutable, and a [copyWith] method is provided
/// for creating new instances with modified values.
class AddPaymentState extends Equatable {
  /// Constructs an [AddPaymentState].
  ///
  /// [formula] and [athlete] are optional and can be null.
  /// [cause], [amount], and [date] are initialized with default values.
  /// [status] defaults to [FormzSubmissionStatus.initial].
  /// [error] defaults to an empty string.
  const AddPaymentState({
    this.formula,
    this.athlete,
    this.cause = const NonEmpty.pure(),
    this.amount = const Numeric.pure(),
    this.date = const Date.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The payment formula, which may be null.
  final PaymentFormula? formula;

  /// The athlete associated with the payment, which may be null.
  final Athlete? athlete;

  /// The cause for the payment, which must be a non-empty value.
  final NonEmpty cause;

  /// The amount of the payment, which must be a numeric value.
  final Numeric amount;

  /// The date of the payment.
  final Date date;

  /// The current status of the form submission.
  final FormzSubmissionStatus status;

  /// Any error message related to form submission.
  final String error;

  @override
  List<Object> get props => [cause, amount, date, status, error];

  /// Creates a copy of this state with modified properties.
  ///
  /// Each parameter is optional. If not provided, the current value
  /// of the corresponding property is used.
  AddPaymentState copyWith({
    PaymentFormula? formula,
    Athlete? athlete,
    NonEmpty? cause,
    Numeric? amount,
    Date? date,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return AddPaymentState(
      formula: formula ?? this.formula,
      athlete: athlete ?? this.athlete,
      cause: cause ?? this.cause,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
