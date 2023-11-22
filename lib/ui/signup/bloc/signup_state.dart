part of 'signup_bloc.dart';

enum SignupStep {
  accountType,
  plan,
  societyUser,
  societyData,
  societyAddress,
  societyPaymentDate,
}

enum SignupStatus {
  idle,
  failure,
  submitting,
  success,
}

enum SubscriptionPlan {
  free,
}

class SignupState {

  SignupState({
    this.name = '',
    this.surname = '',
    this.email = '',
    this.confirmEmail = '',
    this.password = '',
    this.confirmPassword = '',
    this.errorMessage = '',
    this.signupStatus = SignupStatus.idle,
    this.signupStep = SignupStep.accountType,
    this.plan = SubscriptionPlan.free,
    this.societyName = '',
    this.societyEmail = '',
    this.societyTaxId = '',
    this.societyPiva = '',
    this.societyFipCode = '',
    this.societyAddress = '',
    this.societyCity = '',
    this.societyCap = '',
    this.closingPayDate1,
    this.closingPayDate2,
    this.totalAmountUnder = 0,
    this.totalAmountMB = 0,
  });

  final SignupStep signupStep;
  final SignupStatus signupStatus;
  final SubscriptionPlan plan;

  final String name;
  final String surname;
  final String email;
  final String confirmEmail;
  final String confirmPassword;
  final String password;

  final String societyName;
  final String societyEmail;
  final String societyTaxId;
  final String societyPiva;
  final String societyFipCode;
  final String societyAddress;
  final String societyCity;
  final String societyCap;

  final DateTime? closingPayDate1;
  final DateTime? closingPayDate2;
  final int totalAmountUnder;
  final int totalAmountMB;

  final String errorMessage;

  SignupState copyWith({
    String? name,
    String? surname,
    String? email,
    String? confirmEmail,
    String? password,
    String? confirmPassword,
    String? errorMessage,

    SignupStatus? signupStatus,
    SignupStep? signupStep,
    SubscriptionPlan? plan,

    String? societyName,
    String? societyEmail,
    String? societyTaxId,
    String? societyPiva,
    String? societyFipCode,
    String? societyAddress,
    String? societyCity,
    String? societyCap,

    DateTime? closingPayDate1,
    DateTime? closingPayDate2,
    int? totalAmountUnder,
    int? totalAmountMB,
  }) {
    return SignupState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      confirmEmail: confirmEmail ?? this.confirmEmail,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      signupStatus: signupStatus ?? this.signupStatus,
      signupStep: signupStep ?? this.signupStep,
      plan: plan ?? this.plan,
      societyName: societyName ?? this.societyName,
      societyEmail: societyEmail ?? this.societyEmail,
      societyAddress: societyAddress ?? this.societyAddress,
      societyCity: societyCity ?? this.societyCity,
      societyCap: societyCap ?? this.societyCap,
      societyTaxId: societyTaxId ?? this.societyTaxId,
      societyFipCode: societyFipCode ?? this.societyFipCode,
      societyPiva: societyPiva ?? this.societyPiva,
      closingPayDate1: closingPayDate1 ?? this.closingPayDate1,
      closingPayDate2: closingPayDate2 ?? this.closingPayDate2,
      totalAmountUnder: totalAmountUnder ?? this.totalAmountUnder,
      totalAmountMB: totalAmountMB ?? this.totalAmountMB
    );
  }
}