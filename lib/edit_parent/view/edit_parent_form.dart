import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/edit_parent/cubit/edit_parent_cubit.dart';

/// A form widget for editing the details of a parent.
///
/// This widget allows users to update the parent's name, surname, email, and phone number.
/// It uses a BLoC pattern to manage the state and handle form submission.
class EditParentForm extends StatelessWidget {
  /// Creates an instance of [EditParentForm].
  ///
  /// The [parent] parameter is required and represents the parent entity to be edited.
  const EditParentForm({
    super.key,
    required this.parent,
  });

  /// The parent entity to be edited.
  final Parent parent;

  @override
  Widget build(BuildContext context) {
    final state = context.read<EditParentCubit>().state;

    // Controllers for the form fields, initialized with the parent's current data.
    final nameController = TextEditingController(
      text: parent.fullName?.split(' ').first ?? '',
    );
    final surnameController = TextEditingController(
      text: parent.fullName?.split(' ').last ?? '',
    );
    final emailController = TextEditingController(text: parent.email);
    final phoneController = TextEditingController(text: parent.phone);

    // Global key for the form to validate and manage its state.
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
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(
              'Edit Parent',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
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
              // Validate the form and update the parent if valid.
              if (formKey.currentState!.validate()) {
                await context
                    .read<EditParentCubit>()
                    .updateParent(
                  name: nameController.text,
                  surname: surnameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                )
                    .then((_) => Navigator.of(context).pop());
              }
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
