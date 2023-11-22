import 'package:flutter/material.dart';
import 'package:sdeng/ui/add_athlete/view/components/add_athlete_form.dart';

class AddAthleteMobile extends StatelessWidget {
  const AddAthleteMobile({Key? key, required this.teamId}) : super(key: key);

  final String teamId;

  @override
  Widget build(BuildContext context) {
    return AddAthleteForm(teamId: teamId);
  }

}
