import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sdeng/common/team_tile.dart';
import 'package:sdeng/common/text_title.dart';
import 'package:sdeng/common/tool_card.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/model/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/homepage_staff/bloc/home_staff_bloc.dart';

class HomeStaffMobile extends StatelessWidget {
  const HomeStaffMobile({super.key});

  @override
  Widget build(BuildContext context) {
    List<Team> teamsList = context.read<HomeStaffBloc>().state.teamsList;

    return BlocBuilder<HomeStaffBloc, HomeStaffState>(
      builder: (context, state) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeStaffBloc>().loadLeagues();
              },
              color: MyColors.primaryColorDark,
              child: SafeArea(
                minimum: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const TextTitle('Your Teams'),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: teamsList.length,
                          itemBuilder: ((context, index) {
                            final key = Key(teamsList[index].name);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Slidable(
                                  key: key,
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
                                                    title: const Text('Are you sure to remove this team?', style: TextStyle(color: Colors.black, fontSize: 20),),
                                                    content: const Text('This action can\'t be undo!',  style: TextStyle(color: Colors.black)),
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
                                            context.read<HomeStaffBloc>().deleteTeam(teamsList[index].docId);
                                            context.read<HomeStaffBloc>().loadLeagues();
                                          }
                                        },
                                        backgroundColor: const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete_rounded,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: TeamTileWidget(
                                    team: teamsList[index],
                                  ),
                                ),
                              ),
                            );
                          })
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: TextTitle('Tools'),
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: const [
                          InkWell(
                            child: ToolCard(title: 'Calendar', asset: 'assets/illustrations/calendar.svg',),
                          ),
                          ToolCard(title: 'Search', asset: 'assets/illustrations/calendar.svg',),
                          ToolCard(title: 'Payments', asset: 'assets/illustrations/payments.svg',),
                          ToolCard(title: 'Med Visits', asset: 'assets/illustrations/medicine.svg',),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}
