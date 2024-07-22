import 'package:athletes_repository/athletes_repository.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/widgets/add_medical_form.dart';
import 'package:user_repository/user_repository.dart';

class AddMedicalModal extends StatelessWidget {
  const AddMedicalModal({
    super.key,
    required this.athlete,
  });

  static Route<void> route(Athlete athlete) =>
      MaterialPageRoute<void>(builder: (_) => AddMedicalModal(
        athlete: athlete,
      ));

  static const String name = '/addMedicalModal';

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AthleteCubit(
        athletesRepository: context.read<AthletesRepository>(),
        medicalsRepository: context.read<MedicalsRepository>(),
        paymentsRepository: context.read<PaymentsRepository>(),
        documentsRepository: context.read<DocumentsRepository>(),
        userRepository: context.read<UserRepository>(),
        athleteId: athlete.id,
        athlete: athlete,
      ),
      child: const AddMedicalForm(),
    );
  }
}
