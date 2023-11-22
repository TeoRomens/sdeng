import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:sdeng/ui/credits/credits_screen.dart';
import 'package:sdeng/ui/login/view/login.dart';
import 'package:sdeng/ui/profile/bloc/profile_bloc.dart';
import 'package:sdeng/ui/root/bloc/bottom_nav_bloc.dart';
import 'package:sdeng/util/res_helper.dart';

class ProfileColumn extends StatelessWidget{
  const ProfileColumn({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = GetIt.instance<AuthRepository>().getCurrentUser();
    final bloc = context.read<ProfileBloc>();
    final resHelper = ResponsiveHelper(context: context);

    return Column(
      children: [
        const SizedBox(height: 50,),
        const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 80,)
        ),
        const SizedBox(height: 10,),
        Text(
          user!.displayName ?? 'Error',
          style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 20,),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.search_rounded),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            title: const Text(
              'Search Athlete',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            ),
            onTap: () {
              if(resHelper.isMobile){

              } else {
                bloc.selectMenu(SelectedMenu.search);
              }
            }
        ),
        const SizedBox(height: 10),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.settings),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            ),
            onTap: () {
              if(resHelper.isMobile){

              } else {
                bloc.selectMenu(SelectedMenu.settings);
              }
            }
        ),
        const SizedBox(height: 10),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: const Icon(Icons.abc),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            title: const Text(
              'Credits',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            ),
            onTap: () {
              if(resHelper.isMobile){
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Credits(),
                    )
                );
              } else {
                bloc.selectMenu(SelectedMenu.credits);
              }
            }
        ),
        const SizedBox(height: 10,),
        ListTile(
            tileColor: const Color(0xffe8e8e8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            leading: SvgPicture.asset('assets/icons/google.svg', height: 28,),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
            title: const Text(
              'Link Google Account',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            ),
            onTap: () async {
              await bloc.linkGoogleAccount();
            }
        ),
        const SizedBox(height: 20,),
        ElevatedButton(
            onPressed: () async {
              await context.read<BottomNavBarBloc>().logout();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const Login(),
                  )
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "Logout",
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            )
        ),
      ],
    );
  }

}