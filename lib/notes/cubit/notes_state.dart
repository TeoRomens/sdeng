part of 'notes_cubit.dart';

/// The possible states for the [NotesCubit].
enum NotesStatus {
  initial,
  loading,
  populated,
  failure,
}

/// State representation for the [NotesCubit].
class NotesState extends Equatable {
  /// Creates an instance of [NotesState].
  ///
  /// The [status] is required, while [notes] and [error] have default values.
  const NotesState({
    required this.status,
    this.notes = const [],
    this.error = '',
  });

  /// Creates an initial state for [NotesState] with [NotesStatus.initial].
  const NotesState.initial()
      : this(
    status: NotesStatus.initial,
  );

  /// The current status of the notes.
  final NotesStatus status;

  /// The list of notes.
  final List<Note> notes;

  /// Error message, if any.
  final String error;

  @override
  List<Object> get props => [
    status,
    notes,
    error,
  ];

  /// Creates a copy of the current state with optional new values.
  ///
  /// The provided values will replace the current values if they are not `null`.
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

