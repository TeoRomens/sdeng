import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/payment_details/view/payment_details_view.dart';

class PaymentDetailsPage extends StatelessWidget {
  const PaymentDetailsPage({super.key, required this.payment});

  static MaterialPageRoute<void> route(Payment payment) {
    return MaterialPageRoute(
        builder: (_) => PaymentDetailsPage(payment: payment));
  }

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return orientation == Orientation.portrait
          ? PaymentDetailsView(
            payment: payment
          )
          : PaymentDetailsView(
            payment: payment
          );
      }
    );
  }
}
