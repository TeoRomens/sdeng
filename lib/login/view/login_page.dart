import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/login/login.dart';
import 'package:sdeng/login/view/login_view.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
        settings: const RouteSettings(name: name),
      );

  static const String name = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const LoginView(),
    );
  }
}
