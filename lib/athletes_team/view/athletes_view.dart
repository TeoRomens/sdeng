import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athletes_team/athletes.dart';
import 'package:sdeng/add_athlete/view/add_athlete_modal.dart';

class AthletesView extends StatelessWidget {
  const AthletesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AthletesCubit>();

    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
        actions: [
          PopupMenuButton(
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
                    onTap: () {
                      //TODO
                    },
                    child: const Row(
                      children: [
                        Icon(FeatherIcons.edit, color: Colors.black, size: 20,),
                        SizedBox(width: 12,),
                        Text('Rename'),
                      ],
                    )
                ),
                PopupMenuItem(
                    height: 40,
                    onTap: () {
                      context.read<AthletesCubit>().deleteTeam(bloc.state.team!.id);
                    },
                    child: const Row(
                      children: [
                        Icon(FeatherIcons.trash, color: Colors.red, size: 20,),
                        SizedBox(width: 12,),
                        Text('Delete'),
                      ],
                    )
                )
              ]
          ),
        ],
      ),
      body: BlocListener<AthletesCubit,AthletesState>(
        listener: (context, state) {
          if (state.status == AthletesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          }
          if (state.status == AthletesStatus.teamDeleted) {
            Navigator.of(context).pop();
          }
        },
        child: const AthletesScreen()
      ),
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class AthletesScreen extends StatelessWidget {
  /// Main view of Athletes.
  const AthletesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthletesCubit>();

    return RefreshIndicator.adaptive(
      onRefresh: () => bloc.getAthletesFromTeam(bloc.state.team!.id),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBox(
                title: '${bloc.state.team?.name}',
                content: 'Below you find all the athletes you have added to team ${bloc.state.team?.name}. Tap on a player to see the details.'
            ),
            bloc.state.status == AthletesStatus.loading
              ? const LoadingBox()
              : bloc.state.athletes.isEmpty
              ? EmptyState(
                  actionText: 'New athlete',
                  onPressed: () {

                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: bloc.state.athletes.length,
                        itemBuilder: (_,index) => AthleteTile(
                          athlete: bloc.state.athletes[index],
                          trailing: const Padding(
                            padding: EdgeInsets.only(right: AppSpacing.md),
                            child: Icon(FeatherIcons.chevronRight),
                          ),
                        ),
                        separatorBuilder: (_,index) => const Divider(height: 0, indent: 20,),
                      ),
                    const Divider(indent: 70, height: 0),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppSpacing.sm,
                          left: AppSpacing.xlg
                      ),
                      child: AppTextButton(
                          text: 'Add athlete',
                          onPressed: () async => await showAppModal(
                            context: context,
                            content: AddAthleteModal(teamId: bloc.state.team!.id,),
                          ).then((_) => bloc.getAthletesFromTeam(bloc.state.team!.id))
                      ),
                    ),
                  ],
              ),
            const SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}