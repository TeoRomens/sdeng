import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_state.dart';

/// Cubit for managing the state of notes.
class NotesCubit extends Cubit<NotesState> {
  /// Creates an instance of [NotesCubit].
  ///
  /// The [notesRepository] is used to fetch, add, and delete notes.
  NotesCubit({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesState.initial());

  final NotesRepository _notesRepository;

  /// Fetches the list of notes from the repository and updates the state.
  Future<void> getNotes() async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      final notes = await _notesRepository.getNotes();
      emit(state.copyWith(status: NotesStatus.populated, notes: notes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotesStatus.failure));
      addError(error, stackTrace);
    }
  }

  /// Adds a new note and updates the state.
  ///
  /// Takes [author] and [content] as parameters to create a new note.
  Future<void> addNote({
    required String author,
    required String content,
  }) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      final note = await _notesRepository.addNote(
        author: author,
        content: content,
      );
      // Add the newly created note to the current list and update the state.
      final updatedNotes = List<Note>.from(state.notes)..add(note);
      emit(state.copyWith(status: NotesStatus.populated, notes: updatedNotes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotesStatus.failure));
      addError(error, stackTrace);
    }
  }

  /// Deletes a note by [id] and updates the state.
  Future<void> deleteNote(String id) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate a delay
      // Remove the note with the given [id] from the current list and update the state.
      final updatedNotes = state.notes.where((note) => note.id != id).toList();
      emit(state.copyWith(status: NotesStatus.populated, notes: updatedNotes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotesStatus.failure));
      addError(error, stackTrace);
    }
  }
}
