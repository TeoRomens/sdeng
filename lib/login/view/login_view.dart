import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/forgot_password/forgot_password.dart';
import 'package:sdeng/login/login.dart';
import 'package:sdeng/register/view/register_page.dart';
import 'package:sdeng/splash/splash.dart';

/// The [LoginView] widget provides the user interface for the login page.
///
/// It includes fields for email and password input, a button for Google login,
/// and navigation options to register or reset the password. It also listens
/// to the [LoginBloc] to handle authentication state changes and display appropriate messages.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // Navigate to the splash screen if login is successful
        if (state.status.isSuccess) {
          Navigator.of(context).pushReplacement(SplashScreen.route());
        }
        // Show an error message if login fails
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: AppColors.red,
                content: Text(state.error),
              ),
            );
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * .95,
                  maxWidth: 400,
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.xxlg),
                  children: [
                    // App logo
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppLogo.light(),
                    ),
                    const SizedBox(height: AppSpacing.xlg),

                    // Login title
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Log in to access all the features',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xlg),
                    PrimaryButton(
                      key: const Key('loginForm_googleLogin_appButton'),
                      onPressed: () => context.read<LoginBloc>().googleSubmitted(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Assets.icons.google.svg(),
                        ],
                      ),
                    ),
                    const Divider(height: AppSpacing.xxlg),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return Form(
                          key: formKey,
                          child: Column(
                            children: [
                              AppTextFormField(
                                controller: emailController,
                                label: 'Email',
                                hintText: 'Your email address',
                                readOnly: state.status.isInProgress,
                                prefix: const Icon(FeatherIcons.mail),
                                validator: (value) => state.email.validator(value ?? '')?.text,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              AppTextFormField(
                                controller: passwordController,
                                label: 'Password',
                                hintText: 'Your password',
                                obscure: true,
                                readOnly: state.status.isInProgress,
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
                                    Text(
                                      'Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: AppColors.white),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  if(formKey.currentState?.validate() ?? false) {
                                    context.read<LoginBloc>().loginWithCredentials(
                                    email: Email.dirty(emailController.text),
                                    password: Password.dirty(passwordController.text));
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xlg),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Don\'t have an account?',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(RegisterPage.route());
                          },
                          child: Text(
                            'Register',
                            style: UITextStyle.bodyMedium.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        MediaQuery.orientationOf(context) == Orientation.portrait
                            ? showAppModal(
                          context: context,
                          content: const ForgotPasswordModal(),
                        )
                            : showAppSideModal(
                          context: context,
                          content: const ForgotPasswordModal(),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
