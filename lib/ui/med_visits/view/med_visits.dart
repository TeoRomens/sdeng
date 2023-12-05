import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/med_visits/bloc/med_bloc.dart';
import 'package:sdeng/ui/med_visits/view/med_visits_mobile.dart';
import 'package:sdeng/util/res_helper.dart';

class MedVisits extends StatelessWidget {
  const MedVisits({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => MedBloc()..load(),
        child: ResponsiveWidget(
          mobile: Scaffold(
              appBar: AppBar(
                title: const Text('Medical Visits',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              body: const MedVisitsMobile()
          ),
          desktop: const MedVisitsMobile(),
        ),
      );
  }
}
