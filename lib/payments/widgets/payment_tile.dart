import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';

class PaymentTile extends StatelessWidget{
  const PaymentTile({super.key,
    required this.payment,
    this.onTap
  });

  final Payment payment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 16,
      contentPadding: const EdgeInsets.only(
          right: 10
      ),
      visualDensity: VisualDensity.compact,
      leading: SizedBox(
        height: 34,
        child: payment.method == PaymentMethod.transfer
            ? Assets.images.paymentSepa.svg()
            : payment.method == PaymentMethod.cash
            ? Assets.images.paymentCash.svg() : Assets.images.paymentMastercard.svg(),
      ),
      title: Text(payment.cause),
      subtitle: Text(payment.createdAt.dMY),
      trailing: payment.amount > 0
          ? Text('+ \$${payment.amount.toString()}')
          : Text('- \$${payment.amount.toString()}'),
      titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
          color: Colors.black,
          height: 1.6
      ),
      subtitleTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: Color(0xFF475467),
      ),
      leadingAndTrailingTextStyle: TextStyle(
        color: payment.amount > 0 ? const Color(0xFF079455) : AppColors.red,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
      onTap: onTap,
    );
  }
}