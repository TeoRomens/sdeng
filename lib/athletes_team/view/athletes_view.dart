import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sdeng/athlete/view/athlete_page.dart';
import 'package:sdeng/athletes_team/athletes.dart';
import 'package:sdeng/add_athlete/view/add_athlete_modal.dart';

class AthletesView extends StatelessWidget {
  const AthletesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AthletesCubit>();

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
                onPressed: () async => await showAppModal(
                  context: context,
                  content: AddAthleteModal(teamId: bloc.state.team!.id,),
                ).then((_) => bloc.getAthletesFromTeam(bloc.state.team!.id))
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
                    onTap: () => Navigator.of(context).push(AthletePage.route(
                        athleteId: bloc.state.athletes[index].id)
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