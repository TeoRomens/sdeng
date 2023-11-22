import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/profile/bloc/profile_bloc.dart';
import 'package:sdeng/ui/profile/view/profile_desktop.dart';
import 'package:sdeng/ui/profile/view/profile_mobile.dart';
import 'package:sdeng/util/res_helper.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Profile(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(),
      child: Scaffold(
         body: BlocListener<ProfileBloc, ProfileState> (
           listener: (context, state) {

           },
           child: const ResponsiveWidget(
             mobile: ProfileMobile(),
             desktop: ProfileDesktop(),
           ),
         ) ,
      ),
    );
  }
}