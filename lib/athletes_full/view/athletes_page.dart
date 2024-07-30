import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athletes_full/view/athletes_view_desktop.dart';
import 'package:sdeng/athletes_full/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_full/view/athletes_view.dart';

class AthletesPage extends StatelessWidget {
  const AthletesPage({
    super.key,
  });

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AthletesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthletesPageCubit(
        athletesRepository: context.read<AthletesRepository>(),
      )..getAthletes(),
      child: BlocListener<AthletesPageCubit, AthletesPageState>(
        listener: (context, state) {
          if (state.status == AthletesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text(state.error)
                ),
              );
          } else if (state.status == AthletesStatus.teamDeleted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
          ),
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return orientation == Orientation.portrait
                ? const AthletesView()
                : const AthletesViewDesktop();
            },
          ),
        ),
      ),
    );
  }
}
