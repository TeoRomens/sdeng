import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/add_athlete/cubit/add_athlete_cubit.dart';

class AddAthleteForm extends StatefulWidget {
  const AddAthleteForm({
    super.key,
  });

  @override
  State<AddAthleteForm> createState() => _AddAthleteFormState();
}

class _AddAthleteFormState extends State<AddAthleteForm> {
  final _nameController = TextEditingController();

  final _surnameController = TextEditingController();

  final _taxcodeController = TextEditingController();

  final _birthController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _addressController = TextEditingController();

  final _formKey0 = GlobalKey<FormState>();

  final _formKey1 = GlobalKey<FormState>();

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              currentPageIndex == 0 ? _firstPage(context) : const SizedBox(),
              currentPageIndex == 1 ? _secondPage(context) : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _firstPage(BuildContext context) {
    final state = context.watch<AddAthleteCubit>().state;

    return ListView(
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
            'New Athlete',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(endIndent: 0, indent: 0, height: 25),
        AppTextFormField(
          label: 'Name',
          controller: _nameController,
          validator: (value) => state.name.validator(value ?? '')?.text,
        ),
        AppTextFormField(
          label: 'Surname',
          controller: _surnameController,
          validator: (value) => state.surname.validator(value ?? '')?.text,
        ),
        AppTextFormField(
          label: 'Tax ID',
          controller: _taxcodeController,
          validator: (value) => state.taxCode.validator(value ?? '')?.text,
        ),
        const SizedBox(height: AppSpacing.xlg),
        PrimaryButton(
          onPressed: () async {
            _formKey0.currentState!.validate()
                ? setState(() => currentPageIndex = 1)
                : null;
          },
          child: Text(
            'Next',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.xlg),
      ],
    );
  }

  Widget _secondPage(BuildContext context) {
    final state = context.watch<AddAthleteCubit>().state;

    return Form(
      key: _formKey1,
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
              'New Athlete',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(endIndent: 0, indent: 0, height: 25),
          AppTextFormField(
            label: 'Birthdate',
            controller: _birthController,
            validator: (value) => state.birthdate.validator(value ?? '')?.text,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now());
              if (pickedDate != null) {
                _birthController.text = pickedDate.dMY;
              }
            },
          ),
          AppTextFormField(
            label: 'Address',
            controller: _addressController,
          ),
          AppTextFormField(
            label: 'Email',
            controller: _emailController,
            validator: (value) => state.email.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Phone',
            controller: _phoneController,
            validator: (value) => state.phone.validator(value ?? '')?.text,
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
              onPressed: () async {
                if (_formKey1.currentState!.validate()) {
                  await BlocProvider.of<AddAthleteCubit>(context)
                      .addAthlete(
                        name: _nameController.text,
                        surname: _surnameController.text,
                        taxId: _taxcodeController.text,
                      )
                      .then((_) => Navigator.of(context).pop());
                }
              },
              child: const Text('Skip')),
          PrimaryButton(
            onPressed: () async {
              if (_formKey1.currentState!.validate()) {
                await BlocProvider.of<AddAthleteCubit>(context)
                    .addAthlete(
                      name: _nameController.text,
                      surname: _surnameController.text,
                      taxId: _taxcodeController.text.toUpperCase(),
                      birthdate: _birthController.text.toDateTime,
                      address: _addressController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
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
                : Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.white),
                  ),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
