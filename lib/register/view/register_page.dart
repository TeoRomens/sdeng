import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/register/bloc/register_bloc.dart';
import 'package:sdeng/register/view/register_view.dart';
import 'package:user_repository/user_repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: name),
      builder: (_) => const RegisterPage(),
    );
  }
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
