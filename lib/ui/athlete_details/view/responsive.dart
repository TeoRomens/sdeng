import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/ui/add_athlete/view/add_athlete_mobile.dart';
import 'package:sdeng/ui/athlete_details/bloc/athlete_bloc.dart';
import 'package:sdeng/ui/athlete_details/view/athlete_details_mobile.dart';

class AthleteDetails extends StatelessWidget{
  const AthleteDetails(this.athlete, {super.key});

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athlete Details',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => AthleteBloc(athlete: athlete)..loadAthleteDetails(athlete.parentId, athlete.paymentId),
        child: AthleteDetailsMobile(athlete)
      ),
    );
  }

}