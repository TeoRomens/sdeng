import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sdeng/common/team_tile.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/team.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/homepage_staff/bloc/home_staff_bloc.dart';

class HomeStaffDesktop extends StatelessWidget {
  const HomeStaffDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    List<Team> teamsList = context.read<HomeStaffBloc>().state.teamsList;
    final banners = ['https://upload.wikimedia.org/wikipedia/commons/4/49/A_black_image.jpg'];

    return BlocBuilder<HomeStaffBloc, HomeStaffState>(
      builder: (context, state) {
          return Row(
            children: [
              Expanded(
                flex: 6,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeStaffBloc>().loadLeagues();
                  },
                  color: MyColors.primaryColorDark,
                  child: SafeArea(
                    minimum: const EdgeInsets.all(15),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemCount: teamsList.length,
                        itemBuilder: ((context, index) {
                          final key = Key(teamsList[index].name);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
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
                                                        ),
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
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CarouselSlider.builder(
                        itemCount: banners.length,
                        itemBuilder: (BuildContext context, int index, int realIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                banners[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                            aspectRatio: 16/9,
                            autoPlay: true,
                            viewportFraction: 1
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          surfaceTintColor: Colors.grey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                  "516",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 48
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 25),
                                child: Text(
                                    'Total Players'
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          color: Colors.cyan.shade100,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  Variables.societyName,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

}