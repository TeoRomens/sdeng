import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/profile/bloc/profile_bloc.dart';
import 'package:sdeng/ui/settings/bloc/settings_bloc.dart';
import 'package:sdeng/ui/settings/view/settings_mobile.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Settings(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: Scaffold(
         body: BlocListener<ProfileBloc, ProfileState> (
           listener: (context, state) {

           },
           child: const SettingsMobile()
         ) ,
      ),
    );
  }
}