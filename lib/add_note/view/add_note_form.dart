import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';

/// A form for adding a new note.
class AddNoteForm extends StatelessWidget {
  /// Creates an instance of [AddNoteForm].
  AddNoteForm({super.key});

  // Controllers for text fields
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  // Key for the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesCubit>().state;

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xlg,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(
              'New note',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            height: 25,
          ),
          // Content TextFormField
          AppTextFormField(
            label: 'Content',
            controller: _contentController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
            maxLines: 4,
            onSubmitted: (_) => TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),
          // Author TextFormField
          AppTextFormField(
            label: 'Author',
            controller: _authorController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xlg),
          // Add Button
          PrimaryButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await BlocProvider.of<NotesCubit>(context)
                    .addNote(
                  content: _contentController.text,
                  author: _authorController.text,
                )
                    .then((_) => Navigator.of(context).pop());
              }
            },
            child: state.status == NotesStatus.loading
                ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.white,
                strokeCap: StrokeCap.round,
              ),
            )
                : const Text('Add'),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
