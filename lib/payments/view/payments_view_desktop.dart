import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/add_payment/view/add_payment_modal.dart';
import 'package:sdeng/payment_details/view/payment_details_page.dart';
import 'package:sdeng/payments/payments.dart';

/// A desktop view of payments, including an overview,
/// list of payments, and an option to add new payments.
class PaymentsViewDesktop extends StatelessWidget {
  /// Creates an instance of [PaymentsViewDesktop].
  const PaymentsViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PaymentsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xlg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Logo and Title Section
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Assets.images.logo2.svg(height: 120),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Payments',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ),
          // Vertical Divider
          VerticalDivider(
            width: 1,
            color: AppColors.pastelGrey.withOpacity(0.5),
            thickness: 1,
          ),
          // Payment List and Add Payment Button
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextBox(
                      title: 'Payments',
                      content: 'Here you can find all your transactions.',
                    ),
                    AppTextButton(
                      text: 'Add payment',
                      onPressed: () => showAppModal(
                        context: context,
                        content: const AddPaymentModal(),
                      ),
                    ),
                    // Display EmptyState if no payments are available and not loading
                    if (bloc.state.status != PaymentsStatus.loading && bloc.state.payments.isEmpty)
                      EmptyState(
                        actionText: 'Add payment',
                        onPressed: () => showAppModal(
                          context: context,
                          content: const AddPaymentModal(),
                        ),
                      )
                    // Otherwise, display a ListView of payments
                    else
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.672,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: bloc.state.payments.length,
                          itemBuilder: (context, index) => PaymentTile(
                            payment: bloc.state.payments[index],
                            onTap: () => Navigator.of(context).push(
                              PaymentDetailsPage.route(bloc.state.payments[index]),
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) => const Divider(
                            height: 0,
                            indent: 60,
                            endIndent: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
