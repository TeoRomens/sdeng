import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/edit_parent/cubit/edit_parent_cubit.dart';

class EditParentForm extends StatelessWidget {
  final Parent parent;

  const EditParentForm({
    super.key,
    required this.parent,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<EditParentCubit>().state;

    final nameController =
        TextEditingController(text: parent.fullName?.split(' ').first);
    final surnameController =
        TextEditingController(text: parent.fullName?.split(' ').last);
    final emailController = TextEditingController(text: parent.email);
    final phoneController = TextEditingController(text: parent.phone);

    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xlg,
        ),
        children: [
          const _ModalTitle(),
          const Divider(endIndent: 0, indent: 0, height: 25),
          AppTextFormField(
            label: 'Name',
            controller: nameController,
          ),
          AppTextFormField(
            label: 'Surname',
            controller: surnameController,
          ),
          AppTextFormField(
            label: 'Email',
            controller: emailController,
            validator: (value) => state.email.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Phone',
            controller: phoneController,
            validator: (value) => state.phone.validator(value ?? '')?.text,
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
            onPressed: () async {
              formKey.currentState!.validate()
                  ? await context
                      .read<EditParentCubit>()
                      .updateParent(
                        name: nameController.text,
                        surname: surnameController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                      )
                      .then((_) => Navigator.of(context).pop())
                  : null;
            },
            child: state.status == FormzSubmissionStatus.inProgress
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.white,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : const Text('Save'),
          ),
          const SizedBox(height: AppSpacing.xlg),
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
        'Edit Parent',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
