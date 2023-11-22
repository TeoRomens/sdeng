import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/ui/team_details/bloc/team_details_bloc.dart';
import 'package:sdeng/util/text_util.dart';

class AthleteList extends StatelessWidget{
  const AthleteList({super.key, required this.team});

  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamDetailsBloc, TeamDetailsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<TeamDetailsBloc>().loadAthletes(team.docId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.athletesList.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 8, 12, 8),
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
                            child: ListTile(
                                tileColor: MyColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                leading: Text(
                                  '${state.athletesList[index].number}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  '${state.athletesList[index].name} ${state.athletesList[index].surname}',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  context.read<TeamDetailsBloc>().selectAthlete(state.athletesList[index]);
                                }
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
                const SizedBox(height: 50,)
              ],
            ),
          ),
        );
      }
    );
  }

}