import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/ui/add_athlete/view/add_athlete.dart';
import 'package:sdeng/ui/team_details/bloc/team_details_bloc.dart';
import 'package:sdeng/ui/team_details/view/team_details_desktop.dart';
import 'package:sdeng/ui/team_details/view/team_details_mobile.dart';
import 'package:sdeng/util/res_helper.dart';

class TeamDetails extends StatelessWidget{
  const TeamDetails(this.team, {super.key});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddAthlete(teamId: team.docId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocProvider(
        create: (context) => TeamDetailsBloc()..loadAthletes(team.docId),
        child: ResponsiveWidget(
          mobile: TeamDetailsMobile(team: team),
          desktop: TeamDetailsDesktop(team: team),
        ),
      ),
    );
  }

}