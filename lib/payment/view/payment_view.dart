import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/athlete/athlete.dart';

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
  Athlete? _athlete;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchAthlete();
  }

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
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm
        ),
        child: _loading
          ? const LoadingBox()
          : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFormField(
                    label: 'ID',
                    initialValue: widget.payment.id,
                    readOnly: true,
                  ),
                  AppTextFormField(
                    label: 'Cause',
                    initialValue: widget.payment.cause,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text('Method',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: widget.payment.method == PaymentMethod.cash
                        ? Assets.images.paymentCash.svg()
                        : widget.payment.method == PaymentMethod.transfer
                        ? Assets.images.paymentSepa.svg()
                        : Assets.images.paymentMastercard.svg(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text('Method',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: widget.payment.type == PaymentType.income
                          ? AppColors.green.withOpacity(0.2)
                          : AppColors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: widget.payment.type == PaymentType.income
                          ? Text('Income', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.green.shade900),)
                          : Text('Outcome', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.red.shade900)),
                    )
                  ),
                  AppTextFormField(
                    prefix: const Icon(FeatherIcons.dollarSign),
                    label: 'Amount',
                    initialValue: widget.payment.amount.toStringAsFixed(2),
                  ),
                  AppTextFormField(
                    prefix: const Icon(FeatherIcons.calendar),
                    label: 'Created',
                    initialValue: widget.payment.createdAt.dMY,
                  ),
                  if (_athlete != null ) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text('Athlete',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    AthleteTile(
                      athlete: _athlete!,
                      onTap: () => Navigator.of(context)
                          .push(AthletePage.route(athleteId: _athlete!.id)),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xlg),
                    child: Center(
                      child: SecondaryButton(
                        onPressed: () {
                          context.read<PaymentsRepository>().deletePayment(widget.payment.id)
                            .whenComplete(() => Navigator.of(context).pop());
                        },
                        text: 'Delete',
                      ),
                    ),
                  ),
                ],
            ),
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
