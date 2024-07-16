import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/edit_athlete/cubit/edit_athlete_cubit.dart';

class EditAthleteForm extends StatelessWidget {
  final Athlete athlete;

  const EditAthleteForm({
    super.key,
    required this.athlete,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<EditAthleteCubit>().state;

    final nameController = TextEditingController(text: athlete.fullName.split(' ').first);
    final surnameController = TextEditingController(text: athlete.fullName.split(' ').last);
    final taxcodeController = TextEditingController(text: athlete.taxCode);
    final birthController = TextEditingController(text: athlete.birthdate?.dMY);
    final emailController = TextEditingController(text: athlete.email);
    final phoneController = TextEditingController(text: athlete.phone);
    final addressController = TextEditingController(text: athlete.fullAddress);

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
            validator: (value) => state.name.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Surname',
            controller: surnameController,
            validator: (value) => state.surname.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Tax ID',
            controller: taxcodeController,
            validator: (value) => state.taxCode.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Birthdate',
            controller: birthController,
            validator: (value) => state.birthdate.validator(value ?? '')?.text,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                birthController.text = pickedDate.dMY;
              }
            },
          ),
          AppTextFormField(
            label: 'Address',
            controller: addressController,
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
                ? await context.read<EditAthleteCubit>().updateAthlete(
                    name: nameController.text,
                    surname: surnameController.text,
                    taxCode: taxcodeController.text,
                    birthdate: birthController.text.toDateTime,
                    address: addressController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                  ).then((_) => Navigator.of(context).pop(true))
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
        'Edit Athlete',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
