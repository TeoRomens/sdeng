import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/ui/login/bloc/login_bloc.dart';
import 'package:sdeng/ui/login/view/components/login_form.dart';
import 'package:sdeng/util/ui_utils.dart';
import 'package:sdeng/util/res_helper.dart';

class Login extends StatelessWidget {
  const Login({Key? key, this.autologin = true}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Login(),
    );
  }

  final bool autologin;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) {
        if(autologin) {
          return LoginBloc()..checkSavedCredentials()..checkBiometrics();
        } else {
          return LoginBloc();
        }
      },
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState> (
          listener: (context, state) {
            if (state.loginStatus == LoginStatus.successStaff) {
              Get.offNamed('/');
            }
            if(state.loginStatus == LoginStatus.failure) {
              UIUtils.showError(state.errorMessage);
            }
          },
          child: ResponsiveWidget(
            mobile: LoginMobile(),
            desktop: LoginDesktop(),
          )
        )
      ),
    );
  }
}

class LoginDesktop extends StatelessWidget {
  LoginDesktop({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final resHelper = ResponsiveHelper(context: context);

    return Center(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: resHelper.deviceSize.width / 20),
                child: SvgPicture.asset(
                  'assets/logos/SDENG_logo.svg',
                  width: resHelper.deviceSize.width / 3,
                  color: const Color(0xff4D46B2),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: resHelper.deviceSize.width / 10),
                child: LoginForm(formKey: formKey,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginMobile extends StatelessWidget {
  LoginMobile({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final resHelper = ResponsiveHelper(context: context);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Padding(
                padding: EdgeInsets.only(top: resHelper.deviceSize.height * 0.2, bottom: 50),
                child: SvgPicture.asset(
                  'assets/logos/SDENG_logo.svg',
                  width: resHelper.deviceSize.width * 0.8,
                  color: MyColors.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: resHelper.deviceSize.width * 0.12),
              child: LoginForm(formKey: formKey,),
            ),
          ],
        ),
      ),
    );
  }
}