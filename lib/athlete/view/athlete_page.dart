import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/athlete/athlete.dart';
import 'package:user_repository/user_repository.dart';

/// A page that displays details about a specific athlete.
///
/// This page is responsible for displaying the athlete's information and providing
/// various actions related to the athlete, such as deleting the athlete.
class AthletePage extends StatelessWidget {
  /// Creates an [AthletePage] for the specified [athleteId].
  const AthletePage({
    super.key,
    required this.athleteId,
  });

  /// The ID of the athlete whose details are to be displayed.
  final String athleteId;

  /// Returns a [Route] that navigates to the [AthletePage] for the given [athleteId].
  static Route<bool> route({
    required String athleteId,
  }) {
    return MaterialPageRoute<bool>(
      builder: (_) => AthletePage(
        athleteId: athleteId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthleteCubit(
        athleteId: athleteId,
        athletesRepository: context.read<AthletesRepository>(),
        medicalsRepository: context.read<MedicalsRepository>(),
        paymentsRepository: context.read<PaymentsRepository>(),
        documentsRepository: context.read<DocumentsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..initLoading(),
      child: BlocListener<AthleteCubit, AthleteState>(
        listener: (context, state) {
          if (state.status == AthleteStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
            actions: [
              PopupMenuButton(
                padding: EdgeInsets.zero,
                shape: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color(0xffcccccc), width: 0.5),
                  borderRadius: BorderRadius.circular(7),
                ),
                elevation: 0.5,
                shadowColor: Colors.grey.shade200,
                offset: Offset.fromDirection(20, 30),
                surfaceTintColor: Colors.transparent,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    height: 36,
                    onTap: () async {
                      await context
                          .read<AthleteCubit>()
                          .deleteAthlete()
                          .whenComplete(() => Navigator.of(context).pop());
                    },
                    child: Row(
                      children: [
                        const Icon(
                          FeatherIcons.trash,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return orientation == Orientation.portrait
                    ? const AthleteView()
                    : const AthleteViewDesktop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
