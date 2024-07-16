import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/profile_modal/cubit/profile_cubit.dart';

class ProfileForm extends StatelessWidget {
  ProfileForm({super.key});

  final _presNameController = TextEditingController();

  final _societyPivaController = TextEditingController();

  final _societyAddressController = TextEditingController();

  final _societyEmailController = TextEditingController();

  final _societyNameController = TextEditingController();

  final _societyPhoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ProfileCubit>();

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
          const Divider(endIndent: 0, indent: 0, height: 25),
          AppTextFormField(
            label: 'President Full Name',
            controller: _presNameController,
            validator: (value) => bloc.state.fullName.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Name',
            controller: _societyNameController,
            validator: (value) => bloc.state.societyName.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society PIVA',
            controller: _societyPivaController,
            validator: (value) => bloc.state.societyPiva.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Address',
            controller: _societyAddressController,
            validator: (value) => bloc.state.societyAddress.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Email',
            controller: _societyEmailController,
            validator: (value) => bloc.state.societyEmail.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Phone',
            controller: _societyPhoneController,
            validator: (value) => bloc.state.societyPhone.validator(value ?? '')?.text,
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
            onPressed: () async {
              _formKey.currentState?.validate() ?? false
                ? await bloc.updateProfile(
                    fullName: _presNameController.text,
                    societyName: _societyNameController.text,
                    societyPiva: _societyPivaController.text,
                    societyAddress: _societyAddressController.text,
                    societyEmail: _societyEmailController.text,
                    societyPhone: _societyPhoneController.text
                  ).then((_) => Navigator.of(context).pop())
                : null;
            },
            child: bloc.state.status == FormzSubmissionStatus.inProgress
                ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.white,
                    strokeCap: StrokeCap.round,
                  ),
                )
              : Text('Save', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white
              ),),
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
        'Complete Profile',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}