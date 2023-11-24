import 'package:flutter/material.dart';
import 'package:sdeng/model/payment.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.payment, required this.onTap});

  final Payment payment;
  final Function(BuildContext) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
        leading: const Icon(Icons.check_circle_rounded, color: Colors.green),
        title: Text(
          'Payment ${payment.docId}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 20.0,
              color: Colors.black,
          ),
        ),
        subtitle: Text('Paid on: ${payment.date.toDate().day}/${payment.date.toDate().month}/${payment.date.toDate().year}'),
        trailing: Text('€ ${payment.amount}',
          style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        ),
        onTap: () => onTap
    );
  }

}