import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:sdeng/notes/notes.dart';
import 'package:sdeng/notes/view/notes_view_desktop.dart';

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
      child: BlocListener<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state.status == NotesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
          ),
          body: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return orientation == Orientation.portrait ?
                    const NotesView() : const NotesViewDesktop();
              }
          ),
        ),
      ),
    );
  }
}
