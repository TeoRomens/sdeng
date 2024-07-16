import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athletes_team/view/athletes_page.dart';
import 'package:sdeng/teams/teams.dart';
import 'package:sdeng/teams/view/add_team_modal.dart';

class TeamsViewDesktop extends StatelessWidget {
  const TeamsViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamsCubit,TeamsState>(
      listener: (context, state) {
        if (state.status == TeamsStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error)),
            );
        }
      },
      builder: (BuildContext context, TeamsState state) {
        if(state.status == TeamsStatus.loading){
          return const TeamsLoading();
        }
        else {
          return TeamsPopulatedDesktop(teams: state.teams,);
        }
      },
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class TeamsPopulatedDesktop extends StatefulWidget {
  /// Main view of Athletes.
  TeamsPopulatedDesktop({
    super.key,
    List<Team>? teams,
  })  : _teams = teams ?? [];

  final List<Team> _teams;

  @override
  TeamsPopulatedDesktopState createState() => TeamsPopulatedDesktopState();
}

/// State of AthleteList widget. Made public for testing purposes.
@visibleForTesting
class TeamsPopulatedDesktopState extends State<TeamsPopulatedDesktop> {
  bool _edit = false;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TeamsCubit>();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 0, indent: 0, endIndent: 0, color: AppColors.brightGrey,),
          HomeStats(
            numTeam: widget._teams.length,
            numAthletes: 0,
          ),
          const Divider(height: 0, indent: 0, endIndent: 0, color: AppColors.brightGrey),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xlg - AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xlg - AppSpacing.xs,
                AppSpacing.xs,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Teams', style: UITextStyle.headlineMedium,),
                const Spacer(),
                SizedBox(
                  height: AppSpacing.xxlg - AppSpacing.sm,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _edit = !_edit;
                      });
                    },
                    child: _edit ?
                    const Text('Done', style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700
                    ),) :
                    const Text('Edit', style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700
                    ),),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Icon')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Athletes')),
                    ],
                    rows: List.generate(widget._teams.length,
                        (index) => DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColors.brightGrey,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Icon(FeatherIcons.users,)
                                ),
                                onTap: () => Navigator.of(context).push(AthletesPage.route(team: widget._teams[index]))
                              ),
                              DataCell(
                                Text(widget._teams[index].name),
                                onTap: () => Navigator.of(context).push(AthletesPage.route(team: widget._teams[index]))
                              ),
                              DataCell(
                                  Text(widget._teams[index].numAthletes.toString()),
                                  onTap: () => Navigator.of(context).push(AthletesPage.route(team: widget._teams[index]))
                              )
                            ]
                        )
                    )
                ),
              ),
            ],
          ),
          const Divider(indent: 70, height: 0),
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                left: AppSpacing.xlg
            ),
            child: AppTextButton(
              text: 'Add team',
              onPressed: () async => await showAppSideModal(
                context: context,
                width: 400,
                content: const AddTeamModal(),
              ).then((_) => bloc.getTeams())
            ),
          )
        ],
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