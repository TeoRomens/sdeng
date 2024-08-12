import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/add_team/view/add_team_form.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:sdeng/teams/teams.dart';

class AddTeamModal extends StatelessWidget {
  const AddTeamModal({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const AddTeamModal());

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
