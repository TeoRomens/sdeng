import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/forgot_password/forgot_password.dart';
import 'package:user_repository/user_repository.dart';

class ForgotPasswordModal extends StatelessWidget {
  const ForgotPasswordModal({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => const ForgotPasswordModal(),
    settings: const RouteSettings(name: name),
  );

  static const String name = '/forgotPassword';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const ForgotPasswordForm(),
    );
  }
}
