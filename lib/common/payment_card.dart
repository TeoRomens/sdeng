import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaymentCard extends StatelessWidget{
  const PaymentCard({super.key, required this.quota});

  final int quota;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          width: 2.5,
          color: Color(0xffd7d6ff),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
      shadowColor: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25, bottom: 25),
            child: SvgPicture.asset(
              'assets/illustrations/payments.svg',
              height: 75,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 16),
            child: Column(
              children: [
                const Text(
                  'Quota',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                Text(
                  '€ $quota',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),
                ),
                Text(
                  'Total amount athlete\n have to pay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}