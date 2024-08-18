part of 'payments_cubit.dart';

/// Enum representing the status of the payments data.
enum PaymentsStatus {
  /// Initial state before any data is loaded.
  initial,

  /// State while the data is being loaded.
  loading,

  /// State when data has been successfully loaded.
  populated,

  /// State when an error has occurred during data loading.
  failure,
}

/// The state class for managing the payments data and its status.
class PaymentsState extends Equatable {
  /// Creates an instance of [PaymentsState] with the given parameters.
  const PaymentsState({
    required this.status,
    this.payments = const [],
    this.error = '',
  });

  /// Initializes the state with default values.
  const PaymentsState.initial()
      : this(
    status: PaymentsStatus.initial,
  );

  /// The current status of the payments data.
  final PaymentsStatus status;

  /// The list of payments. Defaults to an empty list if not provided.
  final List<Payment> payments;

  /// Error message in case of a failure. Defaults to an empty string.
  final String error;

  @override
  List<Object> get props => [
    status,
    payments,
    error,
  ];

  /// Creates a copy of the current [PaymentsState] with updated values.
  ///
  /// [status], [payments], and [error] are optional and will only be updated if provided.
  PaymentsState copyWith({
    PaymentsStatus? status,
    List<Payment>? payments,
    String? error,
  }) {
    return PaymentsState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      error: error ?? this.error,
    );
  }
}

