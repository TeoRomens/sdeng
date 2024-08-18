part of 'add_team_cubit.dart';

/// Represents the state of the AddTeamCubit.
class AddTeamState extends Equatable {
  /// Creates an [AddTeamState].
  ///
  /// [name] defaults to an empty [NonEmpty] value.
  /// [status] defaults to [FormzSubmissionStatus.initial].
  /// [error] defaults to an empty string.
  const AddTeamState({
    this.name = const NonEmpty.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The name of the team being added.
  final NonEmpty name;

  /// The current status of the form submission.
  final FormzSubmissionStatus status;

  /// Any error message associated with the current state.
  final String error;

  @override
  List<Object> get props => [name, status, error];

  /// Creates a copy of the current state with the given fields replaced with new values.
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