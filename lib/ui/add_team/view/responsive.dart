import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/add_team/bloc/add_team_bloc.dart';
import 'package:sdeng/ui/add_team/view/add_team_desktop.dart';
import 'package:sdeng/ui/add_team/view/add_team_mobile.dart';
import 'package:sdeng/util/res_helper.dart';

class AddTeam extends StatelessWidget {
  const AddTeam({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const AddTeam(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team'),
      ),
      body: BlocProvider(
        create: (BuildContext context) => AddTeamBloc(),
        child: ResponsiveWidget(
            mobile: AddTeamMobile(),
            desktop: AddTeamDesktop()
        ),
      ),
    );
  }
}