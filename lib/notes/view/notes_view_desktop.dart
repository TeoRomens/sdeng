import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'package:sdeng/add_note/view/add_notes_modal.dart';

/// Main view of Teams.
class NotesViewDesktop extends StatelessWidget {
  /// Main view of Athletes.
  const NotesViewDesktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NotesCubit>();

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
                        child: Assets.images.logo4.svg(height: 120)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ]
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
                        content: 'Here you find all the messaged, todos, reminders for being always on point'
                    ),
                    AppTextButton(
                        text: 'Add note',
                        onPressed: () => showAppModal(
                          context: context,
                          content: const AddNoteModal(),
                        )
                    ),
                    bloc.state.status != NotesStatus.loading && bloc.state.notes.isEmpty
                      ? EmptyState(
                        actionText: 'Add note',
                        onPressed: () {
                          showAppModal(
                            context: context,
                            content: const AddNoteModal(),
                          );
                        },
                      )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * .672
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
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
            ),
          ),
        ],
      ),
    );
  }
}
