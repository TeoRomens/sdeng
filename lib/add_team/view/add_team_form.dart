import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/teams/cubit/teams_cubit.dart';

/// A form widget for adding a new team.
class AddTeamForm extends StatelessWidget {
  /// Creates an [AddTeamForm].
  AddTeamForm({super.key});

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeamsCubit>().state;

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
              'New team',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(endIndent: 0, indent: 0, height: 25),
          AppTextFormField(
            label: 'Name',
            bottomText: "The name can't be empty",
            controller: _nameController,
            validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await context.read<TeamsCubit>().addTeam(name: _nameController.text)
                    .then((_) => Navigator.of(context).pop());
              }
            },
            child: state.status == TeamsStatus.loading
              ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.white,
                  strokeCap: StrokeCap.round,
                ),
              )
              : Text('Add', style: Theme.of(context).textTheme.labelLarge,),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}