import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/add_payment/view/add_payment_modal.dart';
import 'package:sdeng/payment_details/view/payment_details_page.dart';
import 'package:sdeng/payments/payments.dart';

/// Main view of Teams.
@visibleForTesting
class PaymentsView extends StatelessWidget {
  /// Main view of Athletes.
  const PaymentsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PaymentsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextBox(
              title: 'Payments',
              content: 'Here you can find all your transactions.'),
          bloc.state.status != PaymentsStatus.loading &&
                  bloc.state.payments.isEmpty
              ? EmptyState(
                  actionText: 'Add payment',
                  onPressed: () => showAppModal(
                    context: context,
                    content: const AddPaymentModal(),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bloc.state.payments.length,
                  itemBuilder: (context, index) => PaymentTile(
                        payment: bloc.state.payments[index],
                        onTap: () => Navigator.of(context).push(
                            PaymentDetailsPage.route(
                                bloc.state.payments[index])),
                      ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        height: 0,
                        indent: 60,
                        endIndent: 20,
                      )),
          AppTextButton(
              text: 'Add payment',
              onPressed: () => showAppModal(
                    context: context,
                    content: const AddPaymentModal(),
                  ))
        ],
      ),
    );
  }
}
