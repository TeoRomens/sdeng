import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/signup/bloc/signup_bloc.dart';

class SocietyUserForm extends StatelessWidget {
  const SocietyUserForm({super.key,});

  @override
  Widget build(BuildContext context) {
    final societyUserKey = GlobalKey<FormState>();
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 16.0),
          child: Text(
            'Fill out the form to register',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Form(
          key: societyUserKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupNameChanged(value),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupSurnameChanged(value),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Surname'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupEmailChanged(value),
                  controller: emailController,
                  validator: (value) {
                    if(value == null || value.isEmpty) return 'This field is required';
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  onChanged: (value) => context.read<SignupBloc>().signupConfirmEmailChanged(value),
                  validator: (value) {
                    if(value == null) {
                      return 'This field is required';
                    } else if(value != emailController.value.text) {
                      return 'Emails doesn\'t match';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Confirm Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  onChanged: (value) => context.read<SignupBloc>().signupPasswordChanged(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if(value == null) {
                      return 'This field is required';
                    } else if(value != passwordController.value.text) {
                      return 'Passwords doesn\'t match';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                  onChanged: (value) => context.read<SignupBloc>().signupConfirmPasswordChanged(value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if(societyUserKey.currentState!.validate()){
                      context.read<SignupBloc>().nextStep();
                    }
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
