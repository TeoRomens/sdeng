import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/signup/bloc/signup_bloc.dart';

class SocietyAddressForm extends StatelessWidget {
  const SocietyAddressForm({super.key,});

  @override
  Widget build(BuildContext context) {
    final societyAddressKey = GlobalKey<FormState>();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Insert society address',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Form(
          key: societyAddressKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyAddressChanged(value),
                  decoration: const InputDecoration(
                    hintText: 'Address',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyCityChanged(value),
                  decoration: const InputDecoration(
                      hintText: 'City'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSocietyCAPChanged(value),
                  decoration: const InputDecoration(
                      hintText: 'CAP'),
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