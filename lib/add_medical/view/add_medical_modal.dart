import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:sdeng/add_medical/add_medical.dart';

/// A modal for adding a medical record to an athlete's profile.
class AddMedicalModal extends StatelessWidget {
  /// Creates an instance of [AddMedicalModal].
  ///
  /// The [athlete] parameter is required and represents the athlete to whom
  /// the medical record will be added.
  const AddMedicalModal({
    super.key,
    required this.athlete,
  });

  /// Route for navigating to the [AddMedicalModal].
  ///
  /// This static method creates a [MaterialPageRoute] with the given [athlete]
  /// to pass to the modal.
  static Route<void> route(Athlete athlete) => MaterialPageRoute<void>(
    builder: (_) => AddMedicalModal(athlete: athlete),
  );

  /// The route name for [AddMedicalModal].
  static const String name = '/addMedicalModal';

  /// The athlete for whom the medical record is being added.
  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMedicalCubit(
        medicalsRepository: context.read<MedicalsRepository>(),
        athleteId: athlete.id,
      ),
      child: const AddMedicalForm(),
    );
  }
}
