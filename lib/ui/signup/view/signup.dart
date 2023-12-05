import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/ui/signup/view/components/account_type.dart';
import 'package:sdeng/ui/signup/view/components/society_addresses.dart';
import 'package:sdeng/ui/signup/view/components/society_data.dart';
import 'package:sdeng/ui/signup/view/components/society_user.dart';
import 'package:sdeng/ui/signup/view/components/subscriptions.dart';
import 'package:sdeng/util/ui_utils.dart';
import 'package:sdeng/util/res_helper.dart';
import 'package:sdeng/ui/signup/bloc/signup_bloc.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Signup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper resHelper = ResponsiveHelper(context: context);

    return BlocProvider(
        create: (BuildContext context) => SignupBloc(),
        child: BlocListener<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state.signupStatus == SignupStatus.success) {
                Get.offNamed('/');
              }
              if (state.signupStatus == SignupStatus.failure) {
                UIUtils.showError(state.errorMessage);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back_ios_new, color: MyColors.primaryColorDark,)
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backgrounds/background1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: resHelper.deviceSize.height * 0.8,
                      maxWidth: 320
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            final StatelessWidget activeWidget;
                            if(state.signupStep == SignupStep.accountType) {
                              activeWidget = const AccountType();
                            }
                            else if(state.signupStep == SignupStep.plan){
                              activeWidget = const SubscriptionType();
                            }
                            else if(state.signupStep == SignupStep.societyUser){
                              activeWidget = const SocietyUserForm();
                            }
                            else if(state.signupStep == SignupStep.societyData){
                              activeWidget = const SocietyDataForm();
                            }
                            else{
                              activeWidget = const SocietyAddressForm();
                            }
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (Widget child, Animation<double> animation) =>
                                  ScaleTransition(scale: animation, child: child),
                              child: activeWidget,
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }
}

