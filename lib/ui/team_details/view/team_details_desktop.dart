import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/ui/athlete_details/bloc/athlete_bloc.dart';
import 'package:sdeng/ui/athlete_details/view/athlete_details_mobile.dart';
import 'package:sdeng/ui/team_details/bloc/team_details_bloc.dart';
import 'package:sdeng/ui/team_details/view/components/athlete_list.dart';
import 'package:sdeng/ui/team_details/view/shimmer.dart';

class TeamDetailsDesktop extends StatelessWidget {
  const TeamDetailsDesktop({
    super.key,
    required this.team,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamDetailsBloc, TeamDetailsState>(
        builder: (context, state) {
          if (state.pageStatus == TeamDetailsPageStatus.loading) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: ShimmerLoader()
                  ),
                  Expanded(
                    flex: 5,
                    child: SizedBox.shrink()
                  ),
                ],
              ),
            );
          }
          else if (state.pageStatus == TeamDetailsPageStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Load Failed'),
                  const SizedBox(height: 8.0,),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeamDetailsBloc>().loadAthletes(team.docId);
                    },
                    child: const Text('Reload'),
                  )
                ],
              ),
            );
          }
          else {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: AthleteList(team: team),
                  ),
                  VerticalDivider(
                    color: Colors.grey.shade300,
                    indent: 20,
                  ),
                  Expanded(
                    flex: 5,
                    child: state.selectedAthlete == null ?
                      const Center(
                        child: Text('No athlete selected'),
                      ) :
                      BlocProvider(
                        create: (context) => AthleteBloc(athlete: state.selectedAthlete!)..loadAthleteDetails(state.selectedAthlete!.parentId, state.selectedAthlete!.paymentId),
                        child: AthleteDetailsMobile(state.selectedAthlete!)
                      )
                  )
                ],
              ),
            );
          }
        },
      );
  }
}
