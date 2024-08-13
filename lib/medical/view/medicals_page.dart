import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:sdeng/medical/cubit/medical_cubit.dart';
import 'package:sdeng/medical/view/medical_view_desktop.dart';
import 'package:sdeng/medical/view/view.dart';

/// A page that displays medical records, adapting to both portrait and landscape orientations.
class MedicalsPage extends StatelessWidget {
  /// Creates an instance of [MedicalsPage].
  const MedicalsPage({super.key});

  /// Returns a [MaterialPageRoute] to navigate to the [MedicalsPage].
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
      )
        ..getExpiredMedicals()
        ..getExpiringMedicals()
        ..getUnknownMedicals(),
      child: BlocListener<MedicalCubit, MedicalState>(
        listener: (context, state) {
          if (state.status == MedicalStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text('Error getting medical visits.'),
                ),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
          ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? const MedicalView()
                  : const MedicalViewDesktop();
            },
          ),
        ),
      ),
    );
  }
}
