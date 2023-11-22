part of 'settings_bloc.dart';


class SettingsState {
  SettingsState({
    this.biometrics = false,
    this.calendarId = '',
    this.errorMessage = '',
  });

  final bool biometrics;
  final String calendarId;
  final String errorMessage;

  SettingsState copyWith({
    bool? biometrics,
    String? calendarId,
    String? errorMessage,
  }) {
    return SettingsState(
      biometrics: biometrics ?? this.biometrics,
      calendarId: calendarId ?? this.calendarId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}