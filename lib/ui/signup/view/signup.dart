import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/ui/root/view/root_screen.dart';
import 'package:sdeng/ui/signup/view/components/account_type.dart';
import 'package:sdeng/ui/signup/view/components/society_addresses.dart';
import 'package:sdeng/ui/signup/view/components/society_data.dart';
import 'package:sdeng/ui/signup/view/components/society_user.dart';
import 'package:sdeng/ui/signup/view/components/subscriptions.dart';
import 'package:sdeng/util/message_util.dart';
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
              if (state.signupStatus == SignupStatus.submitting) {
                MessageUtil.showLoading();
              }
              if (state.signupStatus == SignupStatus.success) {
                MessageUtil.hideLoading();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RootScreen(),
                  )
                );
              }
              if (state.signupStatus == SignupStatus.failure) {
                MessageUtil.hideLoading();
                MessageUtil.showError(state.errorMessage);
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
                            else if(state.signupStep == SignupStep.societyAddress){
                              activeWidget = const SocietyAddressForm();
                            }
                            else {
                              activeWidget = const SocietyPaymentDatesForm();
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

class SocietyPaymentDatesForm extends StatelessWidget {
  const SocietyPaymentDatesForm({super.key,});

  @override
  Widget build(BuildContext context) {
    SignupBloc bloc = context.read<SignupBloc>();
    final societyPaymentsKey = GlobalKey<FormState>();

    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Insert key dates',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Form(
              key: societyPaymentsKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      onChanged: (value) => bloc.signupSocietyAmountUnderChanged(int.parse(value)),
                      decoration: const InputDecoration(
                        hintText: 'Total Amount Under',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      onChanged: (value) => bloc.signupSocietyAmountMBChanged(int.parse(value)),
                      decoration: const InputDecoration(
                          hintText: 'Total Amount Minibasket'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if(selectedDate != null) {
                          bloc.signupSocietyPayDate1Changed(selectedDate);
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          fixedSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: MyColors.primaryColor),
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                      child: Text(
                          state.closingPayDate1 != null ? '${state.closingPayDate1!.day}/${state.closingPayDate1!.month}/${state.closingPayDate1!.year}' : 'First Pay Date'
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if(selectedDate != null) {
                          bloc.signupSocietyPayDate2Changed(selectedDate);
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          fixedSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: MyColors.primaryColor),
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                      child: Text(
                          state.closingPayDate2 != null ? '${state.closingPayDate2!.day}/${state.closingPayDate2!.month}/${state.closingPayDate2!.year}' : 'Second Pay Date'
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        bloc.createAccount();
                      },
                      child: const Text('Create Account'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}


