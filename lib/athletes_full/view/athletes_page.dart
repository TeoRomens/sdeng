import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athletes_team/view/athletes_view_desktop.dart';
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
      child: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
              ? const AthletesPageView()
              : const AthletesViewDesktop();
        },
      ),
    );
  }
}
