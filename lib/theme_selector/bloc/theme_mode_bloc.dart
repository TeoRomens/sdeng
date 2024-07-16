import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Keeps track of and allows changing the application's [ThemeMode].
class ThemeModeBloc extends HydratedCubit<ThemeMode> {
  /// Create a new object
  ThemeModeBloc() : super(ThemeMode.system);

  @override
  ThemeMode fromJson(Map<dynamic, dynamic> json) =>
      ThemeMode.values[json['theme_mode'] as int];

  @override
  Map<String, int> toJson(ThemeMode state) => {'theme_mode': state.index};
}
