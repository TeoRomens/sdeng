import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/add_athlete/view/components/add_athlete_form.dart';
import 'package:sdeng/util/res_helper.dart';

import '../bloc/add_athlete_bloc.dart';

class AddAthleteDesktop extends StatelessWidget {
  const AddAthleteDesktop({Key? key, required this.teamId}) : super(key: key);

  final String teamId;

  @override
  Widget build(BuildContext context) {
    final resHelper = ResponsiveHelper(context: context);

    return BlocBuilder<AddAthleteBloc, AddAthleteState>(
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                    child: SvgPicture.asset('assets/illustrations/add.svg',
                      width: resHelper.deviceSize.width * 0.25,
                    )
                )
              ),
              Expanded(
                flex: 5,
                child: AddAthleteForm(teamId: teamId)
              ),
            ],
          );
        }
      );
  }

}
