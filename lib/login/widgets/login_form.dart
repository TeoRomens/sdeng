import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/forgot_password/view/forgot_password_modal.dart';
import 'package:sdeng/login/bloc/login_bloc.dart';
import 'package:sdeng/register/view/register_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * .95,
              maxWidth: 400
            ),
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
                const _LoginTitle(),
                const SizedBox(height: AppSpacing.sm),
                const _LoginSubtitle(),
                const SizedBox(height: AppSpacing.xlg),
                _GoogleLoginButton(),
                const Divider(height: AppSpacing.xxlg,),
                _LoginWithCredentials(),
                const SizedBox(height: AppSpacing.xlg),
                const _RegisterAndForgotPassword()
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginTitle extends StatelessWidget {
  const _LoginTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Text(
        'LOGIN',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

class _LoginSubtitle extends StatelessWidget {
  const _LoginSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Log in to access all the features',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      key: const Key('loginForm_googleLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().googleSubmitted(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.google.svg(),
        ],
      ),
    );
  }
}

class _LoginWithCredentials extends StatelessWidget {
  _LoginWithCredentials();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

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
        const SizedBox(height: AppSpacing.sm),
        AppTextFormField(
          controller: _passwordController,
          label: 'Password',
          hintText: 'Your password',
          obscure: true,
          prefix: const Icon(FeatherIcons.lock),
          validator: (value) => state.password.validator(value ?? '')?.text,
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
                    Text('Login', style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.white
                    ),),
                  ],
                ),
          onPressed: () => context.read<LoginBloc>().loginWithCredentials(
            email: Email.dirty(_emailController.text),
            password: Password.dirty(_passwordController.text)
          ),
        )
      ],
    );
  }
}


class _RegisterAndForgotPassword extends StatelessWidget {
  const _RegisterAndForgotPassword();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Don\'t have an account?  '),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(RegisterPage.route());
              },
              child: Text('Register', style: UITextStyle.bodyMedium.copyWith(
                color: AppColors.primary
              ),),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            MediaQuery.sizeOf(context).width < 700 ?
              showAppModal(
                context: context,
                content: const ForgotPasswordModal(),
                //routeSettings: const RouteSettings(name: ForgotPasswordForm.name),
              )
            : showAppSideModal(
                context: context,
                content: const ForgotPasswordModal(),
                //routeSettings: const RouteSettings(name: ForgotPasswordForm.name),
              );
          },
          child: Text('Forgot password?', style: UITextStyle.bodyMedium.copyWith(
              color: AppColors.primary
          ),),
        ),
      ],
    );
  }
}
