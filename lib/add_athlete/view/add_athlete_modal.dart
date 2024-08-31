import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/add_athlete/cubit/add_athlete_cubit.dart';
import 'package:sdeng/add_athlete/view/add_athlete_form.dart';

/// A modal for adding a new athlete.
///
/// This widget provides a modal interface for entering details of a new athlete
/// and uses the [AddAthleteCubit] to manage state and perform actions.
class AddAthleteModal extends StatelessWidget {
  /// Creates an instance of [AddAthleteModal].
  ///
  /// The [teamId] parameter specifies the team to which the athlete will be added.
  const AddAthleteModal({
    super.key,
    required String teamId,
  }) : _teamId = teamId;

  final String _teamId;

  /// Creates a route to display the [AddAthleteModal].
  ///
  /// The [teamId] parameter is passed to the modal to specify the relevant team.
  static Route<void> route(String teamId) {
    return MaterialPageRoute<void>(
      builder: (_) => AddAthleteModal(teamId: teamId),
    );
  }

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
