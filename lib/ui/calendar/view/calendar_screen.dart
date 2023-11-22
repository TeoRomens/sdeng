import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/repositories/calendar_repository.dart';
import 'package:sdeng/ui/calendar/bloc/calendar_bloc.dart';
import 'package:sdeng/ui/calendar/view/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CalendarBloc()..loadCalendar(),
        child: Scaffold(
          body: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              if(state.status == CalendarStatus.loading) {
                return const ShimmerLoader();
              }
              else if(state.calendarId.isEmpty) {
                TextEditingController controller = TextEditingController();
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Follow these staps to add you Google Calendar:'),
                      const Text('1. Go to calendar.google.com and make sure your calendar is set to \'Public'),
                      const Text('2. Copy the CalendarID (you can find it in calendar settings) and paste it below'),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'CalendarID'
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                            onPressed: () {
                              context.read<CalendarBloc>().setCalendarId(controller.value.text);
                              context.read<CalendarBloc>().loadCalendar();
                            },
                            child: const Text('Add Calendar')
                        ),
                      ),
                    ],
                  ),
                );
              }
              else{
                return SafeArea(
                minimum: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                child: SfCalendar(
                  view: CalendarView.week,
                  firstDayOfWeek: 1,
                  todayHighlightColor: MyColors.primaryColorLight,
                  headerStyle: const CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontFamily: 'ProductSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    )
                  ),
                  viewHeaderStyle: const ViewHeaderStyle(
                      dateTextStyle: TextStyle(
                        fontFamily: 'ProductSans',
                        color: Colors.black
                      ),
                      dayTextStyle: TextStyle(
                      fontFamily: 'ProductSans',
                      color: Colors.black
                  )
                  ),
                  appointmentTextStyle: const TextStyle(
                    fontFamily: 'ProductSans',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                  scheduleViewSettings: const ScheduleViewSettings(
                    placeholderTextStyle: TextStyle(
                      fontFamily: 'ProductSans',
                    )
                  ),
                  selectionDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  dataSource: GoogleDataSource(state.appointments),
                  ),
                );
              }
            },
          ),
        ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return Colors.red;
  }
}