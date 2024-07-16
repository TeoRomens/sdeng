import 'package:athletes_repository/athletes_repository.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/athlete_view.dart';

class AthletePage extends StatelessWidget {
  const AthletePage({super.key,
    required this.athleteId,
    this.athlete,
  });

  static Route<bool> route({
    required String athleteId,
    Athlete? athlete,
  }) {
    return MaterialPageRoute<bool>(
      builder: (_) => AthletePage(
        athlete: athlete,
        athleteId: athleteId,
      ),
    );
  }

  final Athlete? athlete;
  final String athleteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthleteCubit(
        athleteId: athleteId,
        athlete: athlete,
        athletesRepository: context.read<AthletesRepository>(),
        medicalsRepository: context.read<MedicalsRepository>(),
        paymentsRepository: context.read<PaymentsRepository>(),
        documentsRepository: context.read<DocumentsRepository>(),
      )..initLoading(),
      child: const AthleteView(),
    );
  }
}