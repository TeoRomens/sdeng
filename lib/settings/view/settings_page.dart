import 'package:flutter/material.dart';
import 'package:sdeng/settings/view/settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const SettingsPage());
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait ?
          const SettingsView() : const SettingsView();
        }
    );
  }
}
