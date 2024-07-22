import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athletes_team/view/athletes_page.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/teams/view/add_team_modal.dart';

class TeamsView extends StatelessWidget {
  const TeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamsCubit,TeamsState>(
      listener: (context, state) {
        if (state.status == TeamsStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error)),
            );
        }
      },
      child: const TeamsScreen()
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class TeamsScreen extends StatelessWidget {
  /// Main view of Teams.
  const TeamsScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TeamsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => bloc.getTeams(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextBox(
                title: 'Teams',
                content: 'Below you find all your team you have created. Go inside to find the players belonging to a specific team.'
              ),
              bloc.state.status == TeamsStatus.loading
                ? const LoadingBox()
                : bloc.state.teams.isEmpty
                ? EmptyState(
                    actionText: 'New team',
                    onPressed: () async => await showAppModal(
                      context: context,
                      content: const AddTeamModal(),
                    ).then((_) => bloc.getTeams())
                  )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: bloc.state.teams.length,
                        itemBuilder: (_,index) => TeamTile(
                          name: bloc.state.teams[index].name,
                          numAthletes:  bloc.state.teams[index].numAthletes,
                          onTap: () => Navigator.of(context).push(AthletesPage.route(team: bloc.state.teams[index])),
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
                          text: 'Add team',
                          onPressed: () async => await showAppModal(
                            context: context,
                            content: const AddTeamModal(),
                          ).then((_) => bloc.getTeams())
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading view of Teams.
@visibleForTesting
class TeamsLoading extends StatelessWidget {
  /// Loading view of teams.
  const TeamsLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeamsCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeStats(
            numTeam: 0,
            numAthletes: 0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xlg - AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.xlg - AppSpacing.xs,
            0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Teams', style: UITextStyle.headlineMedium,),
            ],
          ),
        ),
        const LoadingBox(),
        const Divider(indent: 70, height: 0),
        Padding(
          padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              left: AppSpacing.xlg
          ),
          child: AppTextButton(
              text: 'Add team',
              onPressed: () async => await showAppModal(
                context: context,
                content: const AddTeamModal(),
              ).then((_) => bloc.getTeams())
          ),
        )
      ],
    );
  }
}