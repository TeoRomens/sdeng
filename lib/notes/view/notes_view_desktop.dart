import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'package:sdeng/add_note/view/add_notes_modal.dart';

/// Displays the main view of Notes for desktop layout.
///
/// This widget shows a list of notes, provides a button to add new notes,
/// and displays a brief description of the Notes feature. It's optimized
/// for a desktop view with a two-column layout.
class NotesViewDesktop extends StatelessWidget {
  /// Creates a [NotesViewDesktop].
  const NotesViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotesCubit>();
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Assets.images.logo4.svg(height: 120),
                  ),
                  const SizedBox(height: 8),
                  Text('Notes', style: theme.textTheme.displayMedium),
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: AppColors.pastelGrey.withOpacity(0.5),
            thickness: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg),
              child: Align(
                alignment: Alignment.topCenter,
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
                    bloc.state.status != NotesStatus.loading && bloc.state.notes.isEmpty ?
                      EmptyState(
                          actionText: 'Add note',
                          onPressed: () => showAppModal(
                            context: context,
                            content: const AddNoteModal(),
                          ),
                        ) :
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: screenHeight * 0.672),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: bloc.state.notes.length,
                          itemBuilder: (context, index) => NoteTile(note: bloc.state.notes[index]),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
