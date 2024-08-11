import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:notes_repository/notes_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/home/view/home_view_desktop.dart';
import 'package:sdeng/medical/cubit/medical_cubit.dart';
import 'package:sdeng/notes/cubit/notes_cubit.dart';
import 'package:sdeng/payments/cubit/payments_cubit.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:sdeng/home/view/home_view.dart';
import 'package:sdeng/teams/cubit/teams_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TeamsCubit(
            teamsRepository: context.read<TeamsRepository>(),
          )..getTeams(),
        ),
        BlocProvider(
          create: (context) => MedicalCubit(
            medicalsRepository: context.read<MedicalsRepository>(),
          )
            ..getExpiredMedicals()
            ..getExpiringMedicals()
            ..getGoodMedicals()
            ..getUnknownMedicals(),
        ),
        BlocProvider(
          create: (context) => PaymentsCubit(
            paymentsRepository: context.read<PaymentsRepository>(),
          )..getPayments(),
        ),
        BlocProvider(
          create: (context) => NotesCubit(
            notesRepository: context.read<NotesRepository>(),
          )..getNotes(),
        ),
      ],
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return orientation == Orientation.portrait
            ? const HomeView()
            : const HomeViewDesktop();
      }),
    );
  }
}
