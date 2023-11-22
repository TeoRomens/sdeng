part of 'calendar_bloc.dart';

enum CalendarStatus {
  loading,
  loaded,
  failure
}

class CalendarState {
  CalendarState({
    this.appointments = const [],
    this.status = CalendarStatus.loading,
    this.calendarId = '',
  });

  final List<Event> appointments;
  final String calendarId;
  final CalendarStatus status;

  CalendarState copyWith({
    List<Event>? appointments,
    CalendarStatus? status,
    String? calendarId,
  }) {
    return CalendarState(
      appointments: appointments ?? this.appointments,
      status: status ?? this.status,
      calendarId: calendarId ?? this.calendarId
    );
  }
}