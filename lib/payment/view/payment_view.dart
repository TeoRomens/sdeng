import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';

/// A view that displays detailed information about a payment.
///
/// This screen presents various attributes of a payment in a read-only format.
/// It also includes a button to delete the payment.
class PaymentDetailsView extends StatefulWidget {
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
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  late final Athlete? _athlete;
  bool _loading = true;

  /// Fetches the athlete if the payment is related to an athlete.
  Future<void> fetchAthlete() async {
    try {
      if (widget.payment.athleteId != null) {
        final athlete = await context.read<AthletesRepository>().getAthleteFromId(widget.payment.athleteId!);
        setState(() {
          _athlete = athlete;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Error loading athlete'),
          ),
        );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

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
            _buildPaymentDetailField('ID', widget.payment.id, readOnly: true),
            _buildPaymentDetailField('Cause', widget.payment.cause),
            _buildPaymentDetailField('Method', widget.payment.method.name),
            _buildPaymentDetailField('Type', widget.payment.type.name),
            _buildPaymentDetailField(
              'Amount',
              widget.payment.amount.toStringAsFixed(2),
            ),
            _buildPaymentDetailField('Created', widget.payment.createdAt.dMY),
            _buildPaymentDetailField('Athlete', widget.payment.athleteId),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xlg),
              child: SecondaryButton(
                onPressed: () {
                  context.read<PaymentsRepository>().deletePayment(widget.payment.id)
                    .whenComplete(() => Navigator.of(context).pop());
                },
                text: 'Delete',
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
  Widget _buildPaymentDetailField(String label, String? initialValue, {bool readOnly = false}) {
    return AppTextFormField(
      label: label,
      initialValue: initialValue ?? '',
      readOnly: readOnly,
    );
  }
}
