part of 'athletes_cubit.dart';

enum AthletesStatus {
  initial,
  loading,
  populated,
  failure,
  teamDeleted,
}

class AthletesState extends Equatable {
  const AthletesState({
    required this.status,
    this.team,
    this.athletes = const [],
    this.error = '',
  });

  const AthletesState.initial({Team? team}) : this(
    status: AthletesStatus.initial,
    team: team,
  );

  final AthletesStatus status;
  final Team? team;
  final List<Athlete> athletes;
  final String error;

  @override
  List<Object> get props => [
    team ?? '',
    status,
    athletes,
    error,
  ];

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
