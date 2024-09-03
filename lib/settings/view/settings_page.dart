import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/login/view/login_page.dart';
import 'package:sdeng/settings/view/settings_view.dart';
import 'package:sdeng/settings/view/settings_view_desktop.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            LoginPage.route(),
            (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppLogo.light(),
          centerTitle: true,
        ),
        body: OrientationBuilder(
            builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? const SettingsView()
              : const SettingsViewDesktop();
        }),
      ),
    );
  }
}
