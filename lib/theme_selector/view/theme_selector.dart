import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/theme_selector/theme_selector.dart';

/// A drop down menu to select a new [ThemeMode]
///
/// Requires a [ThemeModeBloc] to be provided in the widget tree
/// (usually above [MaterialApp])
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeModeBloc>().state;
    return DropdownButton(
      key: const Key('themeSelector_dropdown'),
      onChanged: (ThemeMode? selectedThemeMode) => context
          .read<ThemeModeBloc>()
          .onChange(
              Change(currentState: themeMode, nextState: selectedThemeMode!)),
      value: themeMode,
      items: const [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(
            'System',
            key: Key('themeSelector_system_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(
            'Light',
            key: Key('themeSelector_light_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(
            'Dark',
            key: Key('themeSelector_dark_dropdownMenuItem'),
          ),
        ),
      ],
    );
  }
}
