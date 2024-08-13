import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/forgot_password/forgot_password.dart';
import 'package:user_repository/user_repository.dart';

/// A modal that allows users to request a password reset link.
///
/// This widget provides a form where users can input their email address
/// to receive instructions for resetting their password.
class ForgotPasswordModal extends StatelessWidget {
  const ForgotPasswordModal({super.key});

  /// Creates a route for the `ForgotPasswordModal`.
  ///
  /// Returns a [MaterialPageRoute] that displays the `ForgotPasswordModal`.
  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => const ForgotPasswordModal(),
    settings: const RouteSettings(name: name),
  );

  /// The route name for the `ForgotPasswordModal`.
  static const String name = '/forgotPassword';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: ForgotPasswordForm(),
    );
  }
}
