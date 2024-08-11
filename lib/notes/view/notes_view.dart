import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'package:sdeng/add_note/view/add_notes_modal.dart';

/// Main view of Teams.
class NotesView extends StatelessWidget {
  /// Main view of Athletes.
  const NotesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotesCubit>();

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
                content:
                    'Here you find all the messaged, todos, reminders for being always on point'),
            AppTextButton(
                text: 'Add note',
                onPressed: () => showAppModal(
                      context: context,
                      content: const AddNoteModal(),
                    )),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .672),
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
