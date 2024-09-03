import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/profile_modal/cubit/profile_cubit.dart';

/// A widget that provides a form for updating the user's profile.
///
/// This form allows the user to update their profile details including their full name,
/// society name, PIVA, address, email, and phone number. It uses the [ProfileCubit] to
/// manage the state and handle profile updates.
class ProfileForm extends StatefulWidget {
  /// Creates a [ProfileForm] widget.
  ///
  /// [sdengUser] is an optional parameter that provides the initial values for the form
  /// fields. If not provided, the fields will be initialized with empty values.
  const ProfileForm({super.key, this.sdengUser});

  /// The user whose profile is being edited.
  final SdengUser? sdengUser;

  @override
  ProfileFormState createState() => ProfileFormState();
}

class ProfileFormState extends State<ProfileForm> {
  late final TextEditingController _presNameController;
  late final TextEditingController _societyPivaController;
  late final TextEditingController _societyAddressController;
  late final TextEditingController _societyEmailController;
  late final TextEditingController _societyNameController;
  late final TextEditingController _societyPhoneController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _presNameController =
        TextEditingController(text: widget.sdengUser?.fullName ?? '');
    _societyPivaController =
        TextEditingController(text: widget.sdengUser?.societyPiva ?? '');
    _societyAddressController =
        TextEditingController(text: widget.sdengUser?.societyAddress ?? '');
    _societyEmailController =
        TextEditingController(text: widget.sdengUser?.societyEmail ?? '');
    _societyNameController =
        TextEditingController(text: widget.sdengUser?.societyName ?? '');
    _societyPhoneController =
        TextEditingController(text: widget.sdengUser?.societyPhone ?? '');
  }

  @override
  void dispose() {
    _presNameController.dispose();
    _societyPivaController.dispose();
    _societyAddressController.dispose();
    _societyEmailController.dispose();
    _societyNameController.dispose();
    _societyPhoneController.dispose();
    super.dispose();
  }

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
            validator: (value) =>
            bloc.state.fullName.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Name',
            controller: _societyNameController,
            validator: (value) =>
            bloc.state.societyName.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society PIVA',
            controller: _societyPivaController,
            validator: (value) =>
            bloc.state.societyPiva.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Address',
            controller: _societyAddressController,
            validator: (value) =>
            bloc.state.societyAddress.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Email',
            controller: _societyEmailController,
            validator: (value) =>
            bloc.state.societyEmail.validator(value ?? '')?.text,
          ),
          AppTextFormField(
            label: 'Society Phone',
            controller: _societyPhoneController,
            validator: (value) =>
            bloc.state.societyPhone.validator(value ?? '')?.text,
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                await bloc.updateProfile(
                  fullName: _presNameController.text,
                  societyName: _societyNameController.text,
                  societyPiva: _societyPivaController.text,
                  societyAddress: _societyAddressController.text,
                  societyEmail: _societyEmailController.text,
                  societyPhone: _societyPhoneController.text,
                ).then((_) => Navigator.of(context).pop());
              }
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
              : Text('Save',
                  style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}

/// A widget that displays the title for the profile form modal.
///
/// The title is displayed at the top of the form and provides context to the user
/// about the purpose of the form.
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
