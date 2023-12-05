import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/settings/bloc/settings_bloc.dart';
import 'package:sdeng/ui/settings/view/settings_desktop.dart';
import 'package:sdeng/ui/settings/view/settings_mobile.dart';
import 'package:sdeng/util/res_helper.dart';

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
      child: BlocListener<SettingsBloc, SettingsState> (
        listener: (context, state) {

        },
        child: const ResponsiveWidget(
          desktop: SettingsDesktop(),
          mobile: SettingsMobile(),
        )
       ) ,
    );
  }
}