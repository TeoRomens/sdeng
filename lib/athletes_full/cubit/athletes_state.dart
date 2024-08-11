part of 'athletes_cubit.dart';

enum AthletesStatus {
  initial,
  loading,
  populated,
  failure,
  teamDeleted,
}

class AthletesPageState extends Equatable {
  const AthletesPageState({
    required this.status,
    this.athletes = const [],
    this.error = '',
  });

  const AthletesPageState.initial({Team? team})
      : this(
          status: AthletesStatus.initial,
        );

  final AthletesStatus status;
  final List<Athlete> athletes;
  final String error;

  @override
  List<Object> get props => [
        status,
        athletes,
        error,
      ];

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
