part of 'teams_cubit.dart';

enum TeamsStatus {
  initial,
  loading,
  populated,
  failure,
}

class TeamsState extends Equatable {
  const TeamsState({
    required this.status,
    this.teams = const [],
    this.numAthletes = 0,
    this.error = '',
  });

  const TeamsState.initial() : this(
    status: TeamsStatus.initial,
  );

  final TeamsStatus status;
  final List<Team> teams;
  final int numAthletes;
  final String error;

  @override
  List<Object> get props => [
    status,
    teams,
    error,
  ];

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
