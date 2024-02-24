part of 'board_cubit.dart';

@immutable
abstract class BoardState {}

class BoardInitial extends BoardState {}

class BoardEmpty extends BoardState {}

class BoardError extends BoardState {
  BoardError({
    required this.error,
  });

  final String error;
}

class BoardLoaded extends BoardState {
  BoardLoaded({
    required this.posts,
  });

  final Map<String, Note?> posts;
}
