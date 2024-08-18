part of 'athlete_cubit.dart';

/// Enum representing the different statuses that the `AthleteState` can be in.
enum AthleteStatus {
  /// The initial state when the athlete data is not yet loaded.
  initial,

  /// The state when athlete data is being loaded.
  loading,

  /// The state when athlete data has been successfully loaded.
  loaded,

  /// The state when there is an error or failure in loading or processing athlete data.
  failure,
}

/// Represents the state of an athlete in the `AthleteCubit`.
///
/// This state includes information about the athlete, their parent, medical records,
/// payments, documents, and the current status of the state.
class AthleteState extends Equatable {
  /// Creates an instance of `AthleteState`.
  const AthleteState({
    required this.status,
    required this.athleteId,
    this.athlete,
    this.parent,
    this.medical,
    this.payments = const [],
    this.documents = const [],
    this.paymentFormula,
    this.error = '',
  });

  /// Creates an initial `AthleteState` with a given athlete ID and optional athlete data.
  const AthleteState.initial({required String athleteId, Athlete? athlete})
      : this(
    status: AthleteStatus.initial,
    athleteId: athleteId,
    athlete: athlete,
  );

  /// The current status of the state (e.g., initial, loading, loaded, failure).
  final AthleteStatus status;

  /// The ID of the athlete associated with this state.
  final String athleteId;

  /// The athlete's data.
  final Athlete? athlete;

  /// The parent of the athlete.
  final Parent? parent;

  /// The medical records associated with the athlete.
  final Medical? medical;

  /// The list of payments associated with the athlete.
  final List<Payment> payments;

  /// The list of documents associated with the athlete.
  final List<Document> documents;

  /// The payment formula associated with the athlete.
  final PaymentFormula? paymentFormula;

  /// An error message, if any error occurs during state processing.
  final String error;

  /// Returns a list of properties used for value equality comparison in the `Equatable` class.
  @override
  List<Object?> get props => [
    status,
    athlete,
    parent,
    medical,
    payments,
    documents,
    error,
  ];

  /// Creates a copy of the current `AthleteState` with the possibility to override
  /// some of its properties.
  AthleteState copyWith({
    String? athleteId,
    AthleteStatus? status,
    Athlete? athlete,
    Parent? parent,
    Medical? medical,
    List<Payment>? payments,
    List<Document>? documents,
    PaymentFormula? paymentFormula,
    String? error,
  }) {
    return AthleteState(
      status: status ?? this.status,
      athleteId: athleteId ?? this.athleteId,
      athlete: athlete ?? this.athlete,
      parent: parent ?? this.parent,
      medical: medical ?? this.medical,
      payments: payments ?? this.payments,
      documents: documents ?? this.documents,
      paymentFormula: paymentFormula ?? this.paymentFormula,
      error: error ?? this.error,
    );
  }
}
