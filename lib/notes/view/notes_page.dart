import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:sdeng/notes/notes.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});
  
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const NotesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit(
        notesRepository: context.read<NotesRepository>(),
      )..getNotes(),
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait ?
                const NotesView() : const NotesView();
          }
      ),
    );
  }
}
