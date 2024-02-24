part of 'teams_cubit.dart';

@immutable
abstract class TeamsState {}

class TeamsInitial extends TeamsState {}

class TeamsEmpty extends TeamsState {}

class TeamsLoading extends TeamsState {}

class TeamsError extends TeamsState {
  TeamsError({
    required this.error,
  });

  final String error;
}

class TeamsLoaded extends TeamsState {
  TeamsLoaded({
    required this.teams,
  });

  final Map<String, Team> teams;
}
