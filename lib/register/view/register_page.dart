import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/register/bloc/register_bloc.dart';
import 'package:sdeng/register/view/register_view.dart';
import 'package:user_repository/user_repository.dart';

/// A page that provides the registration UI and manages state with [RegisterBloc].
///
/// This page allows users to sign up or log in using Google and email credentials.
class RegisterPage extends StatelessWidget {
  /// Creates a [RegisterPage] instance.
  const RegisterPage({super.key});

  /// Creates a [MaterialPageRoute] for the [RegisterPage].
  ///
  /// Returns a [MaterialPageRoute] with the [RegisterPage] as its builder.
  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (_) => const RegisterPage(),
    );
  }

  /// The route name for the [RegisterPage].
  static const String name = '/signup';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const RegisterView(),
    );
  }
}
