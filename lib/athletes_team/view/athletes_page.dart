import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athletes_team/cubit/athletes_cubit.dart';
import 'package:sdeng/athletes_team/view/athletes_view.dart';
import 'package:sdeng/athletes_team/view/athletes_view_desktop.dart';
import 'package:sdeng/rename_team/view/rename_team_modal.dart';
import 'package:teams_repository/teams_repository.dart';

/// A [StatelessWidget] that represents the main page for viewing athletes of a specific team.
/// It displays a list of athletes and allows actions such as renaming or deleting the team.
class AthletesPage extends StatelessWidget {
  /// Creates an [AthletesPage] with the given [team].
  const AthletesPage({
    required this.team,
    super.key,
  });

  /// A method to create a [MaterialPageRoute] to navigate to this page.
  static Route<void> route({
    required Team team,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => AthletesPage(team: team),
    );
  }

  /// The team whose athletes are being displayed.
  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AthletesCubit(
        team: team,
        athletesRepository: context.read<AthletesRepository>(),
        teamsRepository: context.read<TeamsRepository>(),
      )..getAthletesFromTeam(team.id),
      child: BlocListener<AthletesCubit, AthletesState>(
        listener: (context, state) {
          if (state.status == AthletesStatus.failure) {
            _showErrorSnackBar(context, state.error);
          }
          if (state.status == AthletesStatus.teamDeleted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppLogo.light(),
            centerTitle: true,
            actions: [_buildPopupMenu(context)],
          ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? const AthletesView()
                  : const AthletesViewDesktop();
            },
          ),
        ),
      ),
    );
  }

  /// Displays an error [SnackBar] with the provided [message].
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          content: Text(message),
        ),
      );
  }

  /// Builds the popup menu with options to rename or delete the team.
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffcccccc), width: 0.5),
        borderRadius: BorderRadius.circular(7),
      ),
      elevation: 0.5,
      shadowColor: Colors.grey.shade200,
      offset: Offset.fromDirection(20, 30),
      surfaceTintColor: Colors.transparent,
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 40,
          onTap: () async => await showAppModal(
            context: context,
            content: RenameTeamModal(
              team: context.read<AthletesCubit>().state.team!,
            ),
          ),
          child: const Row(
            children: [
              Icon(FeatherIcons.edit, color: Colors.black, size: 20),
              SizedBox(width: 12),
              Text('Rename'),
            ],
          ),
        ),
        PopupMenuItem(
          height: 40,
          onTap: () => context.read<AthletesCubit>().deleteTeam(
            context.read<AthletesCubit>().state.team!.id,
          ),
          child: const Row(
            children: [
              Icon(FeatherIcons.trash, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }
}
