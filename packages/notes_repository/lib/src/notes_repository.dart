import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';

/// Base failure class for the notes repository failures.
abstract class NotesFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const NotesFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// Thrown when fetching notes fails.
class GetNotesFailure extends NotesFailure {
  /// {@macro get_notes_failure}
  const GetNotesFailure(super.error);
}

/// Thrown when adding a note fails.
class AddNoteFailure extends NotesFailure {
  /// {@macro add_note_failure}
  const AddNoteFailure(super.error);
}

/// A repository that manages teams data.
class NotesRepository {
  /// {@macro teams_repository}
  const NotesRepository({
    required FlutterSdengApiClient apiClient,
  }) : _apiClient = apiClient;

  final FlutterSdengApiClient _apiClient;

  /// Requests notes.
  ///
  /// Supported parameters:
  /// * [limit] - The number of results to return.
  Future<List<Note>> getNotes({
    int? limit,
  }) async {
    try {
      return await _apiClient.getNotes(
        limit: limit,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetNotesFailure(error), stackTrace);
    }
  }

  /// Add a new note.
  ///
  /// Supported parameters:
  /// [author] - The name of the author.
  /// [content] - The text of the note.
  Future<Note> addNote({
    required String author,
    required String content,
  }) async {
    try {
      return await _apiClient.addNote(
        content: content,
        author: author,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(AddNoteFailure(error), stackTrace);
    }
  }
}
