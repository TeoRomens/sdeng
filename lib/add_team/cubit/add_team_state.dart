part of 'add_team_cubit.dart';

class AddTeamState extends Equatable {
  const AddTeamState({
    this.name = const NonEmpty.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final NonEmpty name;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props =>
      [name, status, error];

  AddTeamState copyWith({
    NonEmpty? name,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return AddTeamState(
      name: name ?? this.name,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
