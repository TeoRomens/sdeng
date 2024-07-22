part of 'rename_team_cubit.dart';

class RenameTeamState extends Equatable {
  const RenameTeamState({
    required this.team,
    this.name = const NonEmpty.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final Team team;
  final NonEmpty name;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props => [team, status, error];

  RenameTeamState copyWith({
    Team? team,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return RenameTeamState(
      team: team ?? this.team,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
