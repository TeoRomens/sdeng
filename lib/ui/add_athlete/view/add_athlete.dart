import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sdeng/ui/add_athlete/bloc/add_athlete_bloc.dart';
import 'package:sdeng/ui/add_athlete/view/add_athlete_desktop.dart';
import 'package:sdeng/ui/add_athlete/view/add_athlete_mobile.dart';
import 'package:sdeng/ui/team_details/bloc/team_details_bloc.dart';
import 'package:sdeng/util/ui_utils.dart';
import 'package:sdeng/util/res_helper.dart';

class AddAthlete extends StatelessWidget {
  AddAthlete({Key? key}) : super(key: key);

  final String teamId = Get.parameters['teamId']!;
  final keyDati = GlobalKey<FormState>();
  final keyGenitore = GlobalKey<FormState>();
  final keyQuota = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddAthleteBloc(),
      child: BlocListener<AddAthleteBloc, AddAthleteState> (
        listener: (context, state) {
          if (state.status == Status.failure) {
            UIUtils.showError(state.errorMessage);
          }
          if (state.status == Status.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Lottie.asset('assets/animations/successful.json')
                  )
              ),
            );
            Navigator.of(context).pop();
            context.read<TeamDetailsBloc>().loadAthletes(teamId);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Athlete'),
          ),
          body: ResponsiveWidget(
            mobile: AddAthleteMobile(teamId: teamId,),
            desktop: AddAthleteDesktop(teamId: teamId,),
          ),
        )
      )
    );
  }
}