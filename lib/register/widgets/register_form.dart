import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/register/register.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * .95, maxWidth: 400),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxlg,
              ),
              children: [
                Align(alignment: Alignment.centerLeft, child: AppLogo.light()),
                const SizedBox(height: AppSpacing.xlg),
                const _RegisterTitle(),
                const SizedBox(height: AppSpacing.sm),
                const _RegisterSubtitle(),
                const SizedBox(height: AppSpacing.xlg),
                _GoogleRegisterButton(),
                const Divider(
                  height: AppSpacing.xxlg,
                ),
                _RegisterWithCredentials(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RegisterTitle extends StatelessWidget {
  const _RegisterTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Text(
        'REGISTER',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

class _RegisterSubtitle extends StatelessWidget {
  const _RegisterSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Create an account to access all the features',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class _GoogleRegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      //onPressed: () => context.read<RegisterBloc>().googleSubmitted(),
      child: Assets.icons.google.svg(),
    );
  }
}

class _RegisterWithCredentials extends StatelessWidget {
  _RegisterWithCredentials();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterBloc>().state;

    return Form(
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
                value == state.password.value ? null : 'Passwords don\'t match',
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Checkbox(
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity),
                  activeColor: Colors.deepPurpleAccent,
                  side: const BorderSide(color: Color(0xFFD0D5DD), width: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  value: true,
                  onChanged: (value) {}),
              const SizedBox(width: 4),
              Text(
                'Accept Term of Service',
                style: Theme.of(context).textTheme.labelMedium,
              )
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
              onPressed: () => {
                    formKey.currentState?.validate() ?? false
                        ? null
                        : context.read<RegisterBloc>().signupWithCredentials(
                              email: Email.dirty(_emailController.text),
                              password:
                                  Password.dirty(_passwordController.text),
                            )
                  })
        ],
      ),
    );
  }
}
