import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:sdeng/login/bloc/login_bloc.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.red,
                content: Text('Authentication failure')),
            );
        }
      },
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraints.maxHeight * .95),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(
              AppSpacing.xxlg,
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppLogo.light()
              ),
              const SizedBox(height: AppSpacing.xlg),
              const _ForgotTitle(),
              const SizedBox(height: AppSpacing.sm),
              const _ForgotSubtitle(),
              const SizedBox(height: AppSpacing.xlg),
              _ForgotPasswordButton(),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}

class _ForgotTitle extends StatelessWidget {
  const _ForgotTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Text(
        'Insert your email',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

class _ForgotSubtitle extends StatelessWidget {
  const _ForgotSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'We will send you a link to recover your password',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  _ForgotPasswordButton();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForgotPasswordBloc>().state;

    return Column(
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
                    Text('Send', style: UITextStyle.titleMedium,),
                  ],
                ),
          onPressed: () async => await context.read<LoginBloc>().forgotPassword(
            email: Email.dirty(_emailController.text),
          ).then((_) {
            if(state.status == FormzSubmissionStatus.success) {
              Navigator.of(context).pop();
            }
          }),
        )
      ],
    );
  }
}

@visibleForTesting
class ClearIconButton extends StatelessWidget {
  const ClearIconButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final suffixVisible =
    context.select((LoginBloc bloc) => bloc.state.email.value.isNotEmpty);

    return Padding(
      key: const Key('loginForm_clearIconButton'),
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Visibility(
        visible: suffixVisible,
        child: GestureDetector(
          onTap: onPressed,
          child: const Icon(FeatherIcons.xCircle),
        ),
      ),
    );
  }
}