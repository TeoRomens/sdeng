import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/login/view/login_page.dart';
import 'package:sdeng/register/register.dart';
import 'package:sdeng/splash/splash.dart';

/// A view that provides the user interface for the registration process.
///
/// This view listens to both [AppBloc] and [RegisterBloc] to handle authentication
/// state changes and display error messages if registration fails.
class RegisterView extends StatelessWidget {
  /// Creates a [RegisterView] instance.
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status.isLoggedIn) {
          // Pop all routes on top of login page
          Navigator.of(context)
              .popUntil((route) => route.settings.name == LoginPage.name);
          Navigator.of(context).pushReplacement(SplashScreen.route());
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
                  content: Text(state.error),
                ),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
          ),
          body: RegisterForm(),
        ),
      ),
    );
  }
}
