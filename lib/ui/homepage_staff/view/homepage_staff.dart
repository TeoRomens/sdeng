import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/ui/add_team/view/responsive.dart';
import 'package:sdeng/ui/homepage_staff/bloc/home_staff_bloc.dart';
import 'package:sdeng/ui/homepage_staff/view/home_staff_desktop.dart';
import 'package:sdeng/ui/homepage_staff/view/home_staff_mobile.dart';
import 'package:sdeng/util/res_helper.dart';
import 'package:shimmer/shimmer.dart';

class HomepageStaff extends StatelessWidget{
  const HomepageStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeStaffBloc()..loadLeagues(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddTeam(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<HomeStaffBloc, HomeStaffState>(
          builder: (context, state) {
            if(state.homeStatus == HomeStatus.loading){
              return const ShimmerLoader();
            }
            else if(state.teamsList.isEmpty && state.homeStatus == HomeStatus.loaded){
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeStaffBloc>().loadLeagues();
                },
                color: MyColors.primaryColorDark,
                child: const SafeArea(
                    minimum: EdgeInsets.all(15),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No team added yet!',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text('Add you first team by clicking the plus button on the bottom right',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                ),
              );
            }
            else if(state.homeStatus == HomeStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text('Load Failed :('),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeStaffBloc>().loadLeagues();
                      },
                      child: const Text('Reload'),
                    )
                  ],
                ),
              );
            }
            else {
              return const ResponsiveWidget(
                mobile: HomeStaffMobile(),
                desktop: HomeStaffDesktop(),
              );
            }
          },
        ),
      ),
    );
  }

}

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SafeArea(
          minimum: const EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                child:
                Container(
                  height: 70,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white
                  ),
                ),
              );
            }),
          )
      ),
    );
  }
}

