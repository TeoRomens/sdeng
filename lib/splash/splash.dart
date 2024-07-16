import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SplashScreen());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingBox(),
      ),
    );
  }
}