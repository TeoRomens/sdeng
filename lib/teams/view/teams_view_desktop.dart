import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athletes_team/view/athletes_page.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/add_team/view/add_team_modal.dart';

/// A desktop view for displaying the list of teams in a grid format.
///
/// This widget provides a grid view of teams, allowing users to view details
/// of each team and add new teams. It also handles the display of loading
/// states and errors.
class TeamsViewDesktop extends StatelessWidget {
  /// Creates a [TeamsViewDesktop].
  const TeamsViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TeamsCubit>();

    return BlocListener<TeamsCubit, TeamsState>(
      listener: (context, state) {
        if (state.status == TeamsStatus.failure) {
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
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () => bloc.getTeams(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextBox(
                    title: 'Teams',
                    content: 'Below you find all your teams you have created. Go inside to find the players belonging to a specific team.',
                  ),
                  bloc.state.status == TeamsStatus.loading
                      ? const LoadingBox()
                      : bloc.state.teams.isEmpty
                      ? EmptyState(
                    actionText: 'New team',
                    onPressed: () async => await showAppModal(
                      context: context,
                      content: const AddTeamModal(),
                    ).then((_) => bloc.getTeams()),
                  )
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.6,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: bloc.state.teams.length,
                    itemBuilder: (_, index) => TeamCard(
                      title: bloc.state.teams[index].name,
                      content: Text(
                        bloc.state.teams[index].numAthletes.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      image: Assets.images.logo1.svg(height: 87),
                      action: SecondaryButton(
                        text: 'View',
                        onPressed: () => Navigator.of(context).push(
                          AthletesPage.route(
                            team: bloc.state.teams[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppTextButton(
                    text: 'Add team',
                    onPressed: () async => await showAppSideModal(
                      context: context,
                      content: const AddTeamModal(),
                    ).then((_) => bloc.getTeams()),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
