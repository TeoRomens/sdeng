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
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quota',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                Text(
                  'Total amount athlete have to pay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Text(
              '€ $quota',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            )
          ],
        ),
      ),
    );
  }
}