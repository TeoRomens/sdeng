part of 'add_formula_cubit.dart';

/// Represents the state for adding an athlete.
class AddFormulaState extends Equatable {
  /// Creates an instance of [AddFormulaState].
  ///
  /// The [teamId] is required, while other parameters have default values.
  const AddFormulaState({
    this.name = const NonEmpty.pure(),
    this.full = false,
    this.amount1 = const Numeric.pure(),
    this.date1 = const EmptyDate.pure(),
    this.amount2 = const Numeric.pure(),
    this.date2 = const EmptyDate.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final NonEmpty name;

  final bool full;

  final Numeric amount1;

  final EmptyDate date1;

  final Numeric amount2;

  final EmptyDate date2;

  /// The current status of the form submission.
  final FormzSubmissionStatus status;

  /// An error message, if any.
  final String error;

  @override
  List<Object> get props => [
    name,
    full,
    amount1,
    amount2,
    date1,
    date2,
    status,
    error,
  ];

  AddFormulaState copyWith({
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return AddFormulaState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
