import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:sdeng/util/ui_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class CalendarRepository {

  Future<List<Event>> getAllEvents() async {
    List<Event> events = [];
    try{
      final AuthRepository authRepository = Get.find();
      final GoogleSignInAccount? user = authRepository.googleAccount;

      // Being authorized on mobile means being authenticated
      // if user return not null is authenticated
      if(user != null) {
        debugPrint("Fetching events...");
        final http.Response response = await http.get(
          Uri.parse('https://www.googleapis.com/calendar/v3/calendars/${Variables.calendarId}/events'),
          headers: await user.authHeaders,
        );
        if (response.statusCode != 200) {
          debugPrint('Calendar API gave a ${response.statusCode} '
              'response. Check logs for details.');
          debugPrint('Calendar API ${response.statusCode} response:\n${response.body}');
          UIUtils.showError('Error fetching events');
          return events;
        } else {
          debugPrint('Events Fetched!');
        }

        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        data['items'].forEach((item) => events.add(Event.fromJson(item)));
        return events;
      }
    } catch (e) {
      log(e.toString());
    }
    return events;
  }

  Future<String> getCalendarId() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(Variables.uid)
        .get();

    return data['calendarId'];
  }

  Future<void> setCalendarId(String calendarId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Variables.uid)
        .update({'calendarId': calendarId});
  }

}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource(this.appointments);

  final List<Event> appointments;

  @override
  DateTime getStartTime(int index) {
    return appointments[index].start!.dateTime!;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].endTimeUnspecified != null;
  }

  @override
  DateTime getEndTime(int index) {
    final Event event = appointments[index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start!.dateTime ?? event.start!.dateTime!.toLocal())
        : (event.end!.date != null
            ? event.end!.date!.add(const Duration(days: -1))
            : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments[index].location ?? 'No location';
  }

  @override
  String getNotes(int index) {
    return appointments[index].description ?? 'No description';
  }

  @override
  String getSubject(int index) {
    return appointments[index].summary ?? 'No Title';
  }
}