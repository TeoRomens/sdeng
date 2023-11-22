import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/credits/credits_screen.dart';
import 'package:sdeng/ui/profile/bloc/profile_bloc.dart';
import 'package:sdeng/ui/profile/view/components/profile_col.dart';
import 'package:sdeng/ui/search/view/search.dart';
import 'package:sdeng/ui/settings/view/settings.dart';

class ProfileDesktop extends StatelessWidget {
  const ProfileDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Row(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: ProfileColumn(),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  switch (state.selectedMenu) {
                    case SelectedMenu.none:
                      return const Center(child: Text('Select a field'));
                    case SelectedMenu.settings:
                      return const Settings();
                    case SelectedMenu.search:
                      return const Search();
                    case SelectedMenu.credits:
                      return const Credits();
                  }
                }
              )
            )
          ],
        );
      }
    );
  }
}