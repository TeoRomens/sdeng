import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'package:sdeng/add_note/view/add_notes_modal.dart';

/// Displays the main view of Notes.
///
/// This widget shows a list of notes, provides a button to add new notes,
/// and displays a brief description of the Notes feature.
class NotesView extends StatelessWidget {
  /// Creates a [NotesView].
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotesCubit>();
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextBox(
              title: 'Notes',
              content: 'Here you find all the messages, todos, reminders for being always on point',
            ),
            AppTextButton(
              text: 'Add note',
              onPressed: () => showAppModal(
                context: context,
                content: const AddNoteModal(),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.672),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bloc.state.notes.length,
                itemBuilder: (context, index) => NoteTile(
                  note: bloc.state.notes[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}