
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/signup/bloc/signup_bloc.dart';

class SubscriptionType extends StatelessWidget {
  const SubscriptionType({super.key,});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Choose a plan',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.grey,
                    width: 0.5
                )
            ),
            child: ListTile(
              title: const Text('Free'),
              titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ProductSans'
              ),
              subtitle: const Text('I want a limited experience'),
              subtitleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'ProductSans'
              ),
              onTap: () {
                context.read<SignupBloc>().nextStep();
              },
            ),
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}