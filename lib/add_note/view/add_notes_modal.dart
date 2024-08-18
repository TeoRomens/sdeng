import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'add_note_form.dart';

/// A modal widget for adding a new note.
///
/// This widget provides a form to input and submit a new note.
class AddNoteModal extends StatelessWidget {
  /// Creates an instance of [AddNoteModal].
  const AddNoteModal({super.key});

  /// The route to navigate to this modal.
  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const AddNoteModal());

  /// The route name for this modal.
  static const String name = '/addNoteModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesCubit(
        notesRepository: context.read<NotesRepository>(),
      ),
      child: AddNoteForm(),
    );
  }
}
