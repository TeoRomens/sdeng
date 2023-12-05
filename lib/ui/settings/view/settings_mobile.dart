import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/settings/bloc/settings_bloc.dart';
import 'package:sdeng/ui/settings/view/components/settings_form.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return const Padding(
            padding: EdgeInsets.only(right: 20, top: 10, left: 20),
            child: SingleChildScrollView(
              child: SettingsForm(),
            ),
          );
        }
      ),
    );
  }
}