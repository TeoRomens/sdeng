import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/settings/bloc/settings_bloc.dart';

class SettingsMobile extends StatelessWidget {
  const SettingsMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 30.0, top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                ExpansionTile(
                  leading: const Icon(Icons.edit_calendar),
                  title: const Text(
                    'Calendar Id',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'New calendar id',
                          suffixIcon: IconButton(
                              onPressed: () {

                              },
                              icon: const Icon(Icons.check)
                          )
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ListTile(
                    tileColor: const Color(0xffe8e8e8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    leading: const Icon(Icons.edit),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                    title: const Text(
                      'Society Preferences',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                    onTap: () {

                    }
                ),
                const SizedBox(height: 10),
                ListTile(
                    tileColor: const Color(0xffe8e8e8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    leading: const Icon(Icons.fingerprint),
                    trailing: Switch(
                      value: state.biometrics,
                      onChanged: (bool value) => context.read<SettingsBloc>().setBiometrics(value),
                    ),
                    title: const Text(
                      'Login with Biometrics',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        );
      }
    );
  }
}