part of 'teams_cubit.dart';

/// Represents the various states the [TeamsCubit] can be in.
enum TeamsStatus {
  /// Initial state before any action is taken.
  initial,

  /// State when data is being loaded.
  loading,

  /// State when data is successfully loaded.
  populated,

  /// State when there is an error in loading data.
  failure,
}

/// Represents the state of the teams managed by [TeamsCubit].
class TeamsState extends Equatable {
  /// Constructs a [TeamsState] with the given parameters.
  ///
  /// - [status]: The current status of the state, represented by [TeamsStatus].
  /// - [teams]: A list of teams, defaulting to an empty list.
  /// - [numAthletes]: The total number of athletes across all teams, defaulting to 0.
  /// - [error]: An error message, defaulting to an empty string.
  const TeamsState({
    required this.status,
    this.teams = const [],
    this.numAthletes = 0,
    this.error = '',
  });

  /// Constructs the initial state with [TeamsStatus.initial] status.
  const TeamsState.initial()
      : this(
    status: TeamsStatus.initial,
  );

  /// The current status of the state.
  final TeamsStatus status;

  /// A list of teams.
  final List<Team> teams;

  /// The total number of athletes across all teams.
  final int numAthletes;

  /// An error message, if any.
  final String error;

  @override
  List<Object> get props => [
    status,
    teams,
    error,
  ];

  /// Returns a new instance of [TeamsState] with updated values.
  ///
  /// - [status]: The new status for the state. If not provided, the current status is retained.
  /// - [teams]: The new list of teams. If not provided, the current list of teams is retained.
  /// - [numAthletes]: The new total number of athletes. If not provided, the current number is retained.
  /// - [error]: The new error message. If not provided, the current error message is retained.
  TeamsState copyWith({
    TeamsStatus? status,
    List<Team>? teams,
    int? numAthletes,
    String? error,
  }) {
    return TeamsState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
      numAthletes: numAthletes ?? this.numAthletes,
      error: error ?? this.error,
    );
  }
}
