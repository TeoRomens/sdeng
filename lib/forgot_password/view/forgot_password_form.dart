import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/forgot_password/bloc/forgot_password_bloc.dart';

/// A form for users to request a password reset.
///
/// This form allows users to input their email address and submit a request
/// to receive a password reset link.
class ForgotPasswordForm extends StatelessWidget {
  ForgotPasswordForm({super.key});

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForgotPasswordBloc>().state;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.red,
                content: Text('Authentication failure'),
              ),
            );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight * .95),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.xxlg),
              children: [
                Align(alignment: Alignment.centerLeft, child: AppLogo.light()),
                const SizedBox(height: AppSpacing.xlg),
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Text(
                    'Insert your email',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'We will send you a link to recover your password',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xlg),
                Column(
                  children: [
                    AppTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Your email address',
                      readOnly: state.status.isInProgress,
                      prefix: const Icon(FeatherIcons.mail),
                      validator: (value) => state.email.validator(value ?? '')?.text,
                    ),
                    const SizedBox(height: AppSpacing.xlg),
                    PrimaryButton(
                      child: state.status.isInProgress
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.white,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ],
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Send',
                            style: UITextStyle.titleMedium.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        final email = Email.dirty(_emailController.text);
                        await context.read<ForgotPasswordBloc>().forgotPassword(email: email)
                          .whenComplete(() {
                            if (context.read<ForgotPasswordBloc>().state.status == FormzSubmissionStatus.success) {
                              Navigator.of(context).pop();
                            }
                          });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          );
        },
      ),
    );
  }
}
