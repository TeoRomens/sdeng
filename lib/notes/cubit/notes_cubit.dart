import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesState.initial());

  final NotesRepository _notesRepository;

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
      state.notes.add(note);
      emit(state.copyWith(status: NotesStatus.populated, notes: state.notes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotesStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> deleteNote(String id) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2));
      //await _teamsRepository.deleteTeam(id);
      state.notes.removeWhere((elem) => elem.id == id);
      emit(state.copyWith(status: NotesStatus.populated, notes: state.notes));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotesStatus.failure));
      addError(error, stackTrace);
    }
  }
}
