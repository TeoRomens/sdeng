part of 'medical_cubit.dart';

/// Defines the various states that the medical data can be in.
enum MedicalStatus {
  /// Initial state before any action has been taken.
  initial,

  /// Indicates that data is currently being loaded.
  loading,

  /// Indicates that data has been successfully loaded and populated.
  populated,

  /// Indicates that there was an error during the data fetching process.
  failure,
}

/// The `MedicalState` class represents the state of medical data in the application.
/// It holds lists of medical records that are categorized by their status: expired, expiring, good, or unknown.
class MedicalState extends Equatable {
  /// Creates a new instance of [MedicalState] with the given parameters.
  const MedicalState({
    required this.status,
    this.expiredMedicals = const [],
    this.expiringMedicals = const [],
    this.goodMedicals = const [],
    this.unknownMedicals = const [],
  });

  /// Initial state constructor with the status set to [MedicalStatus.initial].
  const MedicalState.initial()
      : this(status: MedicalStatus.initial);

  /// The current status of the medical data.
  final MedicalStatus status;

  /// List of expired medical records.
  final List<Medical> expiredMedicals;

  /// List of medical records that are nearing their expiration date.
  final List<Medical> expiringMedicals;

  /// List of medical records that are still valid and not close to expiration.
  final List<Medical> goodMedicals;

  /// List of medical records whose status is unknown.
  final List<Medical> unknownMedicals;

  /// Properties used by Equatable to determine equality.
  @override
  List<Object> get props => [
    status,
    expiredMedicals,
    expiringMedicals,
    goodMedicals,
    unknownMedicals,
  ];

  /// Creates a copy of the current [MedicalState] with the option to override specific properties.
  ///
  /// - [status]: The new status to use, or retains the current status if null.
  /// - [expiredMedicals]: The new list of expired medical records, or retains the current list if null.
  /// - [expiringMedicals]: The new list of expiring medical records, or retains the current list if null.
  /// - [goodMedicals]: The new list of good medical records, or retains the current list if null.
  /// - [unknownMedicals]: The new list of unknown medical records, or retains the current list if null.
  MedicalState copyWith({
    MedicalStatus? status,
    List<Medical>? expiredMedicals,
    List<Medical>? expiringMedicals,
    List<Medical>? goodMedicals,
    List<Medical>? unknownMedicals,
  }) {
    return MedicalState(
      status: status ?? this.status,
      expiredMedicals: expiredMedicals ?? this.expiredMedicals,
      expiringMedicals: expiringMedicals ?? this.expiringMedicals,
      goodMedicals: goodMedicals ?? this.goodMedicals,
      unknownMedicals: unknownMedicals ?? this.unknownMedicals,
    );
  }
}

