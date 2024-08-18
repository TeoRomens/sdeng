import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:sdeng/notes/notes.dart';

/// A widget that displays the Notes page.
///
/// This page shows a list of notes and handles the creation and management of notes.
/// It uses [BlocProvider] to manage the state of notes and [BlocListener] to handle errors.
class NotesPage extends StatelessWidget {
  /// Creates a [NotesPage].
  const NotesPage({super.key});

  /// Creates a route for the [NotesPage].
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const NotesPage());
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
                  SnackBar(
                    backgroundColor: AppColors.red,
                    content: Text(state.error)
              ));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
          ),
          body: OrientationBuilder(
            builder: (context, orientation) => orientation == Orientation.portrait
                ? const NotesView()
                : const NotesViewDesktop(),
          ),
        ),
      ),
    );
  }
}