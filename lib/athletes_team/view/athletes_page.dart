import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athletes_team/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_team/view/athletes_view.dart';
import 'package:sdeng/athletes_team/view/athletes_view_desktop.dart';
import 'package:teams_repository/teams_repository.dart';

class AthletesPage extends StatelessWidget {
  const AthletesPage({
    required this.team,
    super.key,
  });

  static Route<void> route({
    required Team team,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => AthletesPage(
        team: team,
      ),
    );
  }

  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthletesCubit(
        team: team,
        athletesRepository: context.read<AthletesRepository>(),
        teamsRepository: context.read<TeamsRepository>(),
      )..getAthletesFromTeam(team.id),
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
              ? const AthletesView()
              : const AthletesViewDesktop();
        },
      ),
    );
  }
}
