import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/home/home.dart';
import 'package:sdeng/login/login.dart';

/// The [SplashScreen] widget is the initial screen of the app.
///
/// It listens to the [AppBloc] state and navigates to either the login screen
/// or the home screen based on the authentication status of the user.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  /// Creates a [Page] for the splash screen.
  static Page<void> page() => const MaterialPage<void>(child: SplashScreen());

  /// Creates a [Route] for the splash screen.
  static Route<void> route() => MaterialPageRoute(
    builder: (context) => const SplashScreen(),
    settings: const RouteSettings(name: name),
  );

  /// The route name for the splash screen.
  static const String name = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          // Navigate to the login screen if the user is unauthenticated
          Navigator.of(context).pushReplacement(LoginPage.route());
        } else if (state.status == AppStatus.ready) {
          // Navigate to the home screen if the app is ready
          Navigator.of(context).pushReplacement(HomePage.route());
        }
      },
      child: const Scaffold(
        body: Center(
          child: LoadingBox(),
        ),
      ),
    );
  }
}
