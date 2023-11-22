import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/signup/bloc/signup_bloc.dart';

class SocietyDataForm extends StatelessWidget {
  const SocietyDataForm({super.key,});

  @override
  Widget build(BuildContext context) {
    final societyDataKey = GlobalKey<FormState>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Insert society data',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Form(
          key: societyDataKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyNameChanged(value),
                  decoration: const InputDecoration(
                    hintText: 'Society Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyTaxIdChanged(value),
                  decoration: const InputDecoration(
                    hintText: 'Society Tax Id',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyPivaChanged(value),
                  decoration: const InputDecoration(
                      hintText: 'P.Iva'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyEmailChanged(value),
                  decoration: const InputDecoration(
                      hintText: 'Society Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyFipCodeChanged(value),
                  decoration: const InputDecoration(
                      hintText: 'FIP Code'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SignupBloc>().logState();
                    context.read<SignupBloc>().nextStep();
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
