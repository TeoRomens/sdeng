import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sdeng/common/player_tile.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/ui/athlete_details/view/responsive.dart';
import 'package:sdeng/ui/team_details/bloc/team_details_bloc.dart';
import 'package:sdeng/util/text_util.dart';
import 'package:sdeng/ui/team_details/view/shimmer.dart';

class TeamDetailsMobile extends StatelessWidget {
  const TeamDetailsMobile({
    super.key,
    required this.team,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamDetailsBloc, TeamDetailsState>(
        builder: (context, state) {
          if (state.pageStatus == TeamDetailsPageStatus.loading) {
            return const ShimmerLoader();
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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TeamDetailsBloc>().loadAthletes(team.docId, Source.server);
              },
              child: SafeArea(
                minimum: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.athletesList.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Slidable(
                                key: Key(state.athletesList[index].surname),
                                dragStartBehavior: DragStartBehavior.start,
                                startActionPane: ActionPane(
                                  motion: const BehindMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext dialogContext) async {
                                        final result = await
                                        showDialog<bool>(
                                            context: dialogContext,
                                            builder: (BuildContext dialogContext) =>
                                                AlertDialog(
                                                  title: const Text('Are you sure to remove this athlete?'),
                                                  content: const Text('This action can\'t be undo!'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () => Navigator.pop(dialogContext, false),
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        )
                                                    ),
                                                    TextButton(
                                                        onPressed: () => Navigator.pop(dialogContext, true),
                                                        child: const Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                )
                                        );
                                        if (result == true) {
                                          context.read<TeamDetailsBloc>().deleteAthlete(state.athletesList[index]);
                                          context.read<TeamDetailsBloc>().loadAthletes(team.docId);
                                        }
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: PlayerTileWidget(
                                  athlete: state.athletesList[index],
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => AthleteDetails(state.athletesList[index])
                                      )
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ),
                      const SizedBox(height: 20,),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                    "Earnings",
                                  style: TextStyle(
                                    color: Colors.black45
                                  ),
                                ),
                                Text(
                                    '€ ${TextUtils.abbreviateK(state.earnings)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              width: 20,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Players",
                                  style: TextStyle(
                                      color: Colors.black45
                                  ),
                                ),
                                Text(
                                    state.athletesList.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              width: 20,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Cash Left",
                                  style: TextStyle(
                                    color: Colors.black45
                                  ),
                                ),
                                Text(
                                    '€ ${TextUtils.abbreviateK(state.cashLeft)}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
  }
}
