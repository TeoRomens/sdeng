import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/login/login.dart';
import 'package:sdeng/login/view/login_view.dart';
import 'package:user_repository/user_repository.dart';

/// The [LoginPage] widget serves as the entry point for the login feature.
///
/// It provides a [BlocProvider] for the [LoginBloc], which manages the state
/// and logic for user authentication. The login UI is provided by the [LoginView].
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  /// Creates a [Route] for the login screen.
  static Route<void> route() => MaterialPageRoute(
    builder: (context) => const LoginPage(),
    settings: const RouteSettings(name: name),
  );

  /// The route name for the login screen.
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
