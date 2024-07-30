import 'package:app_ui/app_ui.dart' hide AthleteCard;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athlete/athlete.dart';
import 'package:sdeng/athletes_team/athletes.dart';
import 'package:sdeng/add_athlete/view/add_athlete_modal.dart';

class AthletesViewDesktop extends StatelessWidget {
  const AthletesViewDesktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthletesCubit>();

    return RefreshIndicator.adaptive(
      onRefresh: () => bloc.getAthletesFromTeam(bloc.state.team!.id),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextBox(
                title: 'Athletes',
                content: 'Below you find all the athletes added to this team. Go inside to find view their details.',
              ),
              bloc.state.status == AthletesStatus.loading
                  ? const LoadingBox()
                  : bloc.state.athletes.isEmpty
                  ? EmptyState(
                actionText: 'New athlete',
                onPressed: () async => await showAppSideModal(
                  context: context,
                  content: AddAthleteModal(teamId: bloc.state.team!.id),
                ).then((_) => bloc.getAthletesFromTeam(bloc.state.team!.id)),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.82,
                ),
                padding: EdgeInsets.zero,
                itemCount: bloc.state.athletes.length,
                itemBuilder: (_, index) => AthleteCard(
                  title: bloc.state.athletes[index].fullName,
                  content: Text(
                    bloc.state.athletes[index].taxCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                  image: Assets.images.logo3.svg(height: 60),
                  action: SecondaryButton(
                    text: 'View',
                    onPressed: () => Navigator.of(context).push(AthletePage.route(athleteId: bloc.state.athletes[index].id)),
                  ),
                ),
              ),
              AppTextButton(
                text: 'Add athlete',
                onPressed: () async => await showAppSideModal(
                  context: context,
                  content: AddAthleteModal(teamId: bloc.state.team!.id),
                ).then((_) => bloc.getAthletesFromTeam(bloc.state.team!.id)),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
