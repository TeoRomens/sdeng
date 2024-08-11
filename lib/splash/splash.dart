import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/home/home.dart';
import 'package:sdeng/login/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SplashScreen());

  static Route<void> route() => MaterialPageRoute(
    builder: (context) => const SplashScreen(),
    settings: const RouteSettings(name: name),
  );

  static const String name = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if(state.status == AppStatus.unauthenticated) {
          Navigator.of(context).pushReplacement(LoginPage.route());
        }
        else if(state.status == AppStatus.ready) {
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
