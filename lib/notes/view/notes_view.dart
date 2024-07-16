import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'package:sdeng/notes/view/add_notes_modal.dart';
import 'package:sdeng/notes/widgets/note_tile.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesState>(
      listener: (context, state) {
        if (state.status == NotesStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error)),
            );
        }
      },
      builder: (BuildContext context, NotesState state) {
          return const NotesPopulated();
      },
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class NotesPopulated extends StatelessWidget {
  /// Main view of Athletes.
  const NotesPopulated({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotesCubit>();

    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextBox(
                title: 'Notes',
                content: 'Here you find all the messaged, todos, reminders for being always on point'
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppSpacing.lg
              ),
              child: AppTextButton(
                  text: 'Add note',
                  onPressed: () => showAppModal(
                    context: context,
                    content: const AddNoteModal(),
                  )
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .672
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bloc.state.notes.length,
                itemBuilder: (context, index) {
                  return NoteTile(
                    note: bloc.state.notes[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
