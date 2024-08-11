import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/teams/cubit/teams_cubit.dart';

class AddTeamForm extends StatelessWidget {
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
          const _ModalTitle(),
          const Divider(
            endIndent: 0,
            indent: 0,
            height: 25,
          ),
          AppTextFormField(
            label: 'Name',
            bottomText: 'The name can\'t be empty',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
          ),
          const SizedBox(
            height: AppSpacing.xlg,
          ),
          PrimaryButton(
            onPressed: () async {
              _formKey.currentState!.validate()
                  ? await BlocProvider.of<TeamsCubit>(context)
                      .addTeam(_nameController.text)
                      .then((_) => Navigator.of(context).pop())
                  : null;
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
                : const Text('Add'),
          ),
          const SizedBox(
            height: AppSpacing.xlg,
          ),
        ],
      ),
    );
  }
}

class _ModalTitle extends StatelessWidget {
  const _ModalTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Text(
        'New team',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
