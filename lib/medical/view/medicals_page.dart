import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:sdeng/medical/cubit/medical_cubit.dart';
import 'package:sdeng/medical/view/view.dart';

class MedicalsPage extends StatelessWidget {
  const MedicalsPage({super.key});
  
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const MedicalsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicalCubit(
        medicalsRepository: context.read<MedicalsRepository>(),
      ) ..getExpiredMedicals()
        ..getExpiringMedicals()
        ..getUnknownMedicals(),
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return orientation == Orientation.portrait ?
                const MedicalView() : const MedicalView();
          }
      ),
    );
  }
}
