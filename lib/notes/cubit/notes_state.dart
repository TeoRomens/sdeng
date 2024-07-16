part of 'notes_cubit.dart';

enum NotesStatus {
  initial,
  loading,
  populated,
  failure,
}

class NotesState extends Equatable {
  const NotesState({
    required this.status,
    this.notes = const [],
    this.error = '',
  });

  const NotesState.initial() : this(
    status: NotesStatus.initial,
  );

  final NotesStatus status;
  final List<Note> notes;
  final String error;

  @override
  List<Object> get props => [
    status,
    notes,
    error,
  ];

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? error,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      error: error ?? this.error,
    );
  }
}
