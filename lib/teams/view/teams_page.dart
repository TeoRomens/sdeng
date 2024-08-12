import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/teams/view/teams_view_desktop.dart';
import 'package:teams_repository/teams_repository.dart';

/// A stateless widget that represents the page for displaying teams.
///
/// The [TeamsPage] provides a [TeamsCubit] to manage the state of the teams
/// and determines whether to show the [TeamsView] or [TeamsViewDesktop]
/// based on the device's orientation.
class TeamsPage extends StatelessWidget {
  /// Creates a [TeamsPage].
  const TeamsPage({super.key});

  /// Provides a route to navigate to the [TeamsPage].
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
        },
      ),
    );
  }
}
