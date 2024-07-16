import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/home/view/home_page.dart';
import 'package:sdeng/login/view/login_page.dart';
import 'package:sdeng/register/register.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status.isLoggedIn) {
          // Pop all routes on top of login page
          Navigator.of(context).popUntil((route) => route.settings.name == LoginPage.name);
          Navigator.of(context).pushReplacement(HomePage.route());
        }
      },
      child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.red,
                    content: Text(state.error)),
                );
            }
          },
        child: Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
          ),
          body: const RegisterForm(),
        ),
      ),
    );
  }
}