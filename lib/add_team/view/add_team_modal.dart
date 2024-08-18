import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/add_team/view/add_team_form.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:sdeng/teams/teams.dart';

/// A modal dialog for adding a new team.
///
/// This widget sets up the necessary [TeamsCubit] provider and displays the [AddTeamForm].
class AddTeamModal extends StatelessWidget {
  /// Creates an [AddTeamModal].
  const AddTeamModal({super.key});

  /// Creates a route for this modal.
  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => const AddTeamModal(),
  );

  /// The route name for this modal.
  static const String name = '/addTeamModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamsCubit(
        teamsRepository: context.read<TeamsRepository>(),
      ),
      child: AddTeamForm(),
    );
  }
}