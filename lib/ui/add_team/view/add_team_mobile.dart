import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/util/ui_utils.dart';

import '../bloc/add_team_bloc.dart';

class AddTeamMobile extends StatelessWidget {
  AddTeamMobile({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocListener<AddTeamBloc, AddTeamState>(
      listener: (context, state) {
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
        }
        if(state.status == Status.failure) {
          UIUtils.showError('Name already used');
        }
      },
      child: Center(
        child: BlocBuilder<AddTeamBloc, AddTeamState>(
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/illustrations/add-team.jpg',
                    height: 300,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      onChanged: (value) => context.read<AddTeamBloc>().nameChangedEventHandler(value),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Team Name'),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        context.read<AddTeamBloc>().submittedEventHandler();
                      }
                    },
                    child: const Text('Add Team'),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}