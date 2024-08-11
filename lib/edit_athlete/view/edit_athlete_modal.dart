import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/edit_athlete/cubit/edit_athlete_cubit.dart';
import 'package:sdeng/edit_athlete/view/edit_athlete_form.dart';

class EditAthleteModal extends StatelessWidget {
  const EditAthleteModal({
    super.key,
    required Athlete athlete,
  }) : _athlete = athlete;

  final Athlete _athlete;

  static Route<void> route(Athlete athlete) => MaterialPageRoute<void>(
      builder: (_) => EditAthleteModal(
            athlete: athlete,
          ));

  static const String name = '/editAthleteModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditAthleteCubit(
        athletesRepository: context.read<AthletesRepository>(),
        athlete: _athlete,
      ),
      child: EditAthleteForm(athlete: _athlete),
    );
  }
}
