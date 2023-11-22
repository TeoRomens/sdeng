import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/ui/payments_expires/bloc/payments_expires_bloc.dart';
import 'package:sdeng/ui/payments_expires/view/payments_expires_mobile.dart';
import 'package:sdeng/ui/payments_expires/view/payments_expires_desktop.dart';
import 'package:sdeng/util/res_helper.dart';

class PaymentExpires extends StatelessWidget {
  const PaymentExpires({Key? key, required this.paymentsList}) : super(key: key);

  Route route() {
    return MaterialPageRoute(
      builder: (context) => PaymentExpires(paymentsList: paymentsList,),
    );
  }

  final List<Payment> paymentsList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PayExpiresBloc()..load(paymentsList),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payments Expired',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        body: ResponsiveWidget(
            mobile: PayExpiresMobile(paymentsList: paymentsList),
            desktop: PayExpiresDesktop(paymentsList: paymentsList)
        ),
      ),
    );
  }
}