import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/add_athlete/cubit/add_athlete_cubit.dart';
import 'package:sdeng/add_athlete/view/add_athlete_form.dart';

class AddAthleteModal extends StatelessWidget {
  const AddAthleteModal({
    super.key,
    required String teamId,
  }) : _teamId = teamId;

  final String _teamId;

  static Route<void> route(String teamId) =>
      MaterialPageRoute<void>(builder: (_) => AddAthleteModal(
        teamId: teamId,
      ));

  static const String name = '/addAthleteModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddAthleteCubit(
        athletesRepository: context.read<AthletesRepository>(),
        teamId: _teamId,
      ),
      child: const AddAthleteForm(),
    );
  }
}
