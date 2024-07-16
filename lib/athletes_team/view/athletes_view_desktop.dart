import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athletes_team/athletes.dart';
import 'package:sdeng/add_athlete/view/add_athlete_modal.dart';
import 'package:sdeng/teams/view/add_team_modal.dart';

class AthletesViewDesktop extends StatelessWidget {
  const AthletesViewDesktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: BlocConsumer<AthletesCubit,AthletesState>(
        listener: (context, state) {
          if (state.status == AthletesStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          }
        },
        builder: (BuildContext context, AthletesState state) {
          if(state.status == AthletesStatus.loading){
            return const AthletesLoading();
          }
          else {
            return AthletesPopulated(athletes: state.athletes,);
          }
        },
      ),
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class AthletesPopulated extends StatefulWidget {
  /// Main view of Athletes.
  AthletesPopulated({
    super.key,
    List<Athlete>? athletes,
  })  : _athletes = athletes ?? [];

  final List<Athlete> _athletes;

  @override
  AthletesPopulatedState createState() => AthletesPopulatedState();
}

/// State of AthleteList widget. Made public for testing purposes.
@visibleForTesting
class AthletesPopulatedState extends State<AthletesPopulated> {
  Athlete? selectedAthlete;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AthletesCubit>();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Text('Athletes', style: UITextStyle.headlineMedium,),
                const Spacer(),
                selectedAthlete != null ? SizedBox(
                  height: AppSpacing.xxlg - AppSpacing.md,
                  child: TextButton(
                    onPressed: () async {
                      await context.read<AthletesCubit>().deleteAthlete(selectedAthlete!.id)
                          .then((value) => context.read<AthletesCubit>().getAthletesFromTeam(bloc.state.team!.id));
                    },
                    child: const Text('Delete', style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700
                    ),),
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Icon')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Tax Code')),
                      DataColumn(label: Text('Birth Date')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                    ],
                    rows: List.generate(widget._athletes.length,
                            (index) => DataRow(
                            selected: selectedAthlete == widget._athletes[index],
                            onSelectChanged: (isSelected) {
                              setState(() {
                                if(selectedAthlete != widget._athletes[index]) {
                                  selectedAthlete = widget._athletes[index];
                                } else {
                                  selectedAthlete = null;
                                }
                              });
                            },
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
                              ),
                              DataCell(
                                  Text(widget._athletes[index].fullName),
                              ),
                              DataCell(
                                  Text(widget._athletes[index].taxCode.toString()),
                              ),
                              DataCell(
                                Text(widget._athletes[index].birthdate?.dMY ?? ''),
                              ),
                              DataCell(
                                Text(widget._athletes[index].email ?? ''),
                              ),
                              DataCell(
                                Text(widget._athletes[index].phone ?? ''),
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
                text: 'Add athlete',
                onPressed: () async => await showAppSideModal(
                  context: context,
                  content: AddAthleteModal(teamId: bloc.state.team!.id),
                ).then((_) => bloc.getAthletesFromTeam(bloc.state.team!.id))
            ),
          )
        ],
      ),
    );
  }
}

/// Loading view of Teams.
@visibleForTesting
class AthletesLoading extends StatelessWidget {
  /// Loading view of teams.
  const AthletesLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AthletesCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Text('Athletes', style: UITextStyle.headlineMedium,),
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
              text: 'Add athlete',
              onPressed: () async => await showAppModal(
                context: context,
                content:  const AddTeamModal(),
              ).then((_) => bloc.getAthletesFromTeam(bloc.state.team!.id))
          ),
        )
      ],
    );
  }
}