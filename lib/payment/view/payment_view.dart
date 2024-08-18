import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';

/// A view that displays detailed information about a payment.
///
/// This screen presents various attributes of a payment in a read-only format.
/// It also includes a button to delete the payment.
class PaymentDetailsView extends StatelessWidget {
  /// Creates an instance of [PaymentDetailsView].
  ///
  /// [payment] is the payment object whose details are to be displayed.
  const PaymentDetailsView({super.key, required this.payment});

  /// Creates a [MaterialPageRoute] to navigate to the [PaymentDetailsView].
  ///
  /// [payment] is the payment object to be displayed.
  static Route<void> route(Payment payment) {
    return MaterialPageRoute<void>(
      builder: (_) => PaymentDetailsView(payment: payment),
    );
  }

  /// The payment object containing details to be displayed.
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentDetailField('ID', payment.id, readOnly: true),
            _buildPaymentDetailField('Cause', payment.cause),
            _buildPaymentDetailField('Method', payment.method.name),
            _buildPaymentDetailField('Type', payment.type.name),
            _buildPaymentDetailField(
              'Amount',
              payment.amount.toStringAsFixed(2),
            ),
            _buildPaymentDetailField('Created', payment.createdAt.dMY),
            _buildPaymentDetailField('Athlete', payment.athleteId!),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xlg),
              child: TextButton(
                onPressed: () {
                  // Implement delete functionality here
                },
                child: Text(
                  'Delete',
                  style: UITextStyle.bodyMedium.copyWith(
                    color: AppColors.red,
                    fontWeight: AppFontWeight.semiBold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a read-only [AppTextFormField] with the given label and initial value.
  ///
  /// [label] is the field label, [initialValue] is the initial value to be displayed,
  /// and [readOnly] determines whether the field is read-only or editable.
  Widget _buildPaymentDetailField(String label, String initialValue, {bool readOnly = false}) {
    return AppTextFormField(
      label: label,
      initialValue: initialValue,
      readOnly: readOnly,
    );
  }
}
