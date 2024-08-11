import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';

class PaymentDetailsView extends StatelessWidget {
  const PaymentDetailsView({super.key, required this.payment});

  static Route<Athlete> route(Payment payment) {
    return MaterialPageRoute<Athlete>(
      builder: (_) => PaymentDetailsView(
        payment: payment,
      ),
    );
  }

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFormField(
              label: 'ID',
              initialValue: payment.id,
              readOnly: true,
            ),
            AppTextFormField(
              label: 'Cause',
              initialValue: payment.cause,
            ),
            AppTextFormField(
              label: 'Method',
              initialValue: payment.method.name,
            ),
            AppTextFormField(
              label: 'Type',
              initialValue: payment.type.name,
            ),
            AppTextFormField(
              label: 'Amount',
              initialValue: payment.amount.toStringAsFixed(2),
            ),
            AppTextFormField(
              label: 'Created',
              initialValue: payment.createdAt.dMY,
            ),
            AppTextFormField(
              label: 'Athlete',
              initialValue: payment.athleteId,
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xlg),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Delete',
                    style: UITextStyle.bodyMedium.copyWith(
                        color: AppColors.red,
                        fontWeight: AppFontWeight.semiBold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
