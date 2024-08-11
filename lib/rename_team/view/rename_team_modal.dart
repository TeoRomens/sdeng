import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/rename_team/cubit/rename_team_cubit.dart';
import 'package:sdeng/rename_team/view/rename_team_form.dart';
import 'package:teams_repository/teams_repository.dart';

class RenameTeamModal extends StatelessWidget {
  const RenameTeamModal({
    super.key,
    required Team team,
  }) : _team = team;

  final Team _team;

  static Route<void> route(Team team) => MaterialPageRoute<void>(
      builder: (_) => RenameTeamModal(
            team: team,
          ));

  static const String name = '/renameTeamModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RenameTeamCubit(
        teamsRepository: context.read<TeamsRepository>(),
        team: _team,
      ),
      child: RenameTeamForm(team: _team),
    );
  }
}
