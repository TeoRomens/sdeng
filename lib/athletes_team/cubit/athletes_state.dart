part of 'athletes_cubit.dart';

/// Enum representing the possible states of the AthletesCubit.
enum AthletesStatus {
  initial,
  loading,
  populated,
  failure,
  teamDeleted,
}

/// Represents the state of the AthletesCubit, including the current status,
/// the associated team, the list of athletes, and any error message.
class AthletesState extends Equatable {
  /// Creates an instance of [AthletesState].
  ///
  /// - [status]: The current status of the state.
  /// - [team]: The team associated with the athletes.
  /// - [athletes]: The list of athletes.
  /// - [error]: Any error message associated with the current state.
  const AthletesState({
    required this.status,
    this.team,
    this.athletes = const [],
    this.error = '',
  });

  /// Initial state factory constructor with an optional team.
  const AthletesState.initial({Team? team})
      : this(
    status: AthletesStatus.initial,
    team: team,
  );

  /// The current status of the athletes state.
  final AthletesStatus status;

  /// The team associated with the current state.
  final Team? team;

  /// The list of athletes.
  final List<Athlete> athletes;

  /// The error message, if any.
  final String error;

  @override
  List<Object> get props => [
    status,
    team ?? '', // Using an empty string to handle the nullable Team object
    athletes,
    error,
  ];

  /// Creates a copy of the current state with the option to override certain fields.
  ///
  /// - [team]: The team associated with the new state.
  /// - [status]: The status of the new state.
  /// - [athletes]: The list of athletes for the new state.
  /// - [error]: The error message for the new state.
  ///
  /// Returns a new instance of [AthletesState].
  AthletesState copyWith({
    Team? team,
    AthletesStatus? status,
    List<Athlete>? athletes,
    String? error,
  }) {
    return AthletesState(
      team: team ?? this.team,
      status: status ?? this.status,
      athletes: athletes ?? this.athletes,
      error: error ?? this.error,
    );
  }
}
