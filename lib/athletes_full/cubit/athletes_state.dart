part of 'athletes_cubit.dart';

/// Enum representing the various statuses that the athletes page can be in.
enum AthletesStatus {
  /// The initial state when nothing has been loaded.
  initial,

  /// Indicates that athletes are currently being loaded.
  loading,

  /// Indicates that the athletes data has been successfully loaded.
  populated,

  /// Indicates that an error occurred while loading athletes data.
  failure,

  /// Indicates that the team associated with the athletes has been deleted.
  teamDeleted,
}

/// A state class that holds the data and status for the athletes page.
///
/// This state includes the current [status], a list of [athletes],
/// and an optional [error] message.
class AthletesPageState extends Equatable {
  /// Creates a new instance of [AthletesPageState].
  ///
  /// The [status] is required. The [athletes] list is optional and defaults
  /// to an empty list. The [error] message is optional and defaults to an
  /// empty string.
  const AthletesPageState({
    required this.status,
    this.athletes = const [],
    this.error = '',
  });

  /// Creates the initial state for the athletes page, with the [status] set to [AthletesStatus.initial].
  const AthletesPageState.initial({Team? team})
      : this(
    status: AthletesStatus.initial,
  );

  /// The current status of the athletes page.
  final AthletesStatus status;

  /// A list of athletes currently displayed on the page.
  final List<Athlete> athletes;

  /// An optional error message in case of a failure.
  final String error;

  @override
  List<Object> get props => [
    status,
    athletes,
    error,
  ];

  /// Returns a copy of the current state with the ability to override specific fields.
  ///
  /// This method allows you to create a new instance of [AthletesPageState]
  /// by modifying only specific properties while keeping the others unchanged.
  AthletesPageState copyWith({
    AthletesStatus? status,
    List<Athlete>? athletes,
    String? error,
  }) {
    return AthletesPageState(
      status: status ?? this.status,
      athletes: athletes ?? this.athletes,
      error: error ?? this.error,
    );
  }
}
