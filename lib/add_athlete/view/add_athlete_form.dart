import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/add_athlete/cubit/add_athlete_cubit.dart';

/// A form widget for adding a new athlete.
/// It includes two pages for collecting athlete details.
class AddAthleteForm extends StatefulWidget {
  /// Creates an instance of [AddAthleteForm].
  const AddAthleteForm({super.key});

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

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              if (_currentPageIndex == 0) _buildFirstPage(context),
              if (_currentPageIndex == 1) _buildSecondPage(context),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the first page of the form for basic athlete details.
  Widget _buildFirstPage(BuildContext context) {
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
          onPressed: () {
            if (_formKey0.currentState!.validate()) {
              setState(() => _currentPageIndex = 1);
            }
          },
          child: Text('Next',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  /// Builds the second page of the form for additional athlete details.
  Widget _buildSecondPage(BuildContext context) {
    final state = context.watch<AddAthleteCubit>().state;

    return Form(
      key: _formKey1,
      child: ListView(
        shrinkWrap: true,
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
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _birthController.text = pickedDate.dMY;
              }
            },
          ),
          AppTextFormField(
            key: const Key('addAthleteForm_address_appTextField'),
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
                await BlocProvider.of<AddAthleteCubit>(context).addAthlete(
                  name: _nameController.text,
                  surname: _surnameController.text,
                  taxId: _taxcodeController.text.toUpperCase(),
                  birthdate: _birthController.text.toDateTime,
                  address: _addressController.text,
                  email: _emailController.text.toLowerCase(),
                  phone: _phoneController.text,
                ).whenComplete(() => Navigator.of(context).pop());
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
                  style: Theme.of(context).textTheme.labelLarge,
                ),
          ),
        ],
      ),
    );
  }
}

