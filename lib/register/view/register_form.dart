import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/register/register.dart';

/// A form for user registration that includes fields for email, password,
/// and password confirmation, as well as a Google sign-up button.
///
/// This form listens to the [RegisterBloc] to manage state and validate input.
class RegisterForm extends StatelessWidget {
  /// Creates a [RegisterForm] instance.
  RegisterForm({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterBloc>().state;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * .95,
              maxWidth: 400,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxlg,
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppLogo.light(),
                ),
                const SizedBox(height: AppSpacing.xlg),
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Text(
                    'REGISTER',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Create an account to access all the features',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xlg),
                PrimaryButton(
                  // Uncomment to enable Google sign-in functionality
                  // onPressed: () => context.read<RegisterBloc>().googleSubmitted(),
                  child: Assets.icons.google.svg(),
                ),
                const Divider(height: AppSpacing.xxlg),
                Form(
                  key: formKey,
                  child: Column(
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
                      const SizedBox(height: AppSpacing.sm),
                      AppTextFormField(
                        label: 'Confirm Password',
                        hintText: 'Confirm password',
                        obscure: true,
                        prefix: const Icon(FeatherIcons.lock),
                        validator: (value) =>
                        value == _passwordController.text ? null : 'Passwords don\'t match',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Checkbox(
                            visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                            ),
                            activeColor: Colors.deepPurpleAccent,
                            side: const BorderSide(color: Color(0xFFD0D5DD), width: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            value: true,
                            onChanged: (value) {},
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Accept Terms of Service',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
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
                            : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Register'),
                          ],
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<RegisterBloc>().signupWithCredentials(
                              email: Email.dirty(_emailController.text),
                              password: Password.dirty(_passwordController.text),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
