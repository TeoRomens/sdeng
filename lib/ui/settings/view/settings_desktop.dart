import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/settings/bloc/settings_bloc.dart';
import 'package:sdeng/ui/settings/view/components/settings_form.dart';

class SettingsDesktop extends StatelessWidget {
  const SettingsDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return const Padding(
          padding: EdgeInsets.only(right: 25, top: 10),
          child: SingleChildScrollView(
            child: SettingsForm(),
          ),
        );
      }
    );
  }
}