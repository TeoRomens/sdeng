import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/teams/view/teams_view_desktop.dart';
import 'package:teams_repository/teams_repository.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const TeamsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamsCubit(
        teamsRepository: context.read<TeamsRepository>(),
      )..getTeams(),
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return orientation == Orientation.portrait
            ? const TeamsView()
            : const TeamsViewDesktop();
      }),
    );
  }
}
