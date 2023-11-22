part of 'add_team_bloc.dart';

enum Status {
  idle,
  submitting,
  failure,
  success
}

class AddTeamState {
  AddTeamState({
    this.name = '',
    this.status = Status.idle,
  });

  final String name;
  final Status status;

  AddTeamState copyWith({
    String? name,
    Status? status,
  }) {
    return AddTeamState(
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }
}