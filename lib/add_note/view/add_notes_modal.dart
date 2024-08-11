import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';

import 'add_note_form.dart';

class AddNoteModal extends StatelessWidget {
  const AddNoteModal({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const AddNoteModal());

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
