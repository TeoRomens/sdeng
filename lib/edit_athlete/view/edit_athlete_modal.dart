import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/edit_athlete/cubit/edit_athlete_cubit.dart';
import 'package:sdeng/edit_athlete/view/edit_athlete_form.dart';

/// A stateless widget that displays a modal dialog for editing an athlete's information.
/// This widget uses [EditAthleteCubit] to manage the state of the form, and passes the
/// [Athlete] object to the [EditAthleteForm] for editing.
class EditAthleteModal extends StatelessWidget {
  /// Constructs an [EditAthleteModal] widget.
  ///
  /// The [athlete] parameter is required to populate the form with the existing
  /// details of the athlete.
  const EditAthleteModal({
    super.key,
    required Athlete athlete,
  }) : _athlete = athlete;

  /// The athlete whose information is being edited.
  final Athlete _athlete;

  /// The name of the route for the [EditAthleteModal], useful for named routes.
  static const String name = '/editAthleteModal';

  /// Creates a [MaterialPageRoute] that navigates to the [EditAthleteModal].
  ///
  /// This method is used to push the modal onto the navigation stack.
  ///
  /// ```dart
  /// Navigator.of(context).push(EditAthleteModal.route(athlete));
  /// ```
  static Route<void> route(Athlete athlete) => MaterialPageRoute<void>(
    builder: (_) => EditAthleteModal(athlete: athlete),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /// Provides the [EditAthleteCubit] to the widget tree.
      ///
      /// The [EditAthleteCubit] is responsible for managing the state of the athlete's form.
      /// It is initialized with the [athletesRepository] and the athlete being edited.
      create: (_) => EditAthleteCubit(
        athletesRepository: context.read<AthletesRepository>(),
        athlete: _athlete,
      ),

      /// The [EditAthleteForm] is the child of the [BlocProvider], allowing it to access
      /// the [EditAthleteCubit] for state management.
      child: EditAthleteForm(athlete: _athlete),
    );
  }
}
