import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athletes_full/view/athletes_view_desktop.dart';
import 'package:sdeng/athletes_full/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_full/view/athletes_view.dart';

/// A [StatelessWidget] that serves as the main page for displaying a list of athletes.
///
/// The `AthletesPage` widget is responsible for initializing the [AthletesPageCubit],
/// handling its state, and rendering the appropriate UI based on the device orientation.
///
/// This page automatically fetches a list of athletes when it is created and listens for
/// any changes in the state of the [AthletesPageCubit] to display error messages or
/// handle specific events like team deletion.
class AthletesPage extends StatelessWidget {
  const AthletesPage({
    super.key,
  });

  /// Creates a [Route] to navigate to the `AthletesPage`.
  ///
  /// This static method can be used to easily navigate to the `AthletesPage`
  /// using Flutter's navigation system.
  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AthletesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Initializes the AthletesPageCubit with the required AthletesRepository
      // and triggers the initial loading of athletes.
      create: (context) => AthletesPageCubit(
        athletesRepository: context.read<AthletesRepository>(),
      )..getAthletes(),

      // Listens for changes in the AthletesPageState and responds accordingly.
      child: BlocListener<AthletesPageCubit, AthletesPageState>(
        listener: (context, state) {
          // If there's a failure, show a snackbar with the error message.
          if (state.status == AthletesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.red,
                  content: Text(state.error),
                ),
              );
          }
          // If the team is deleted, navigate back to the previous page.
          else if (state.status == AthletesStatus.teamDeleted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),  // Display the application logo in the center of the AppBar.
            centerTitle: true,
          ),
          body: OrientationBuilder(
            // Renders different views based on the device's orientation.
            builder: (BuildContext context, Orientation orientation) {
              return orientation == Orientation.portrait
                  ? const AthletesView()        // Use the AthletesView for portrait orientation.
                  : const AthletesViewDesktop(); // Use the AthletesViewDesktop for landscape orientation.
            },
          ),
        ),
      ),
    );
  }
}
