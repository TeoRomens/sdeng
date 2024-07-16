import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/add_payment/view/add_payment_modal.dart';
import 'package:sdeng/payments/payments.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentsCubit, PaymentsState>(
      listener: (context, state) {
        if (state.status == PaymentsStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error)),
            );
        }
      },
      builder: (BuildContext context, PaymentsState state)
          => PaymentsPopulated()
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class PaymentsPopulated extends StatelessWidget {
  /// Main view of Athletes.
  const PaymentsPopulated({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<PaymentsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextBox(
              title: 'Payments',
              content: 'Here you can find all your transactions.'
          ),
          bloc.state.status != PaymentsStatus.loading && bloc.state.payments.isEmpty
            ? EmptyState(
                actionText: 'Add payment',
                onPressed: () {

                }
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bloc.state.payments.length,
                  itemBuilder: (context, index) => PaymentTile(
                      payment: bloc.state.payments[index],
                  ),
                  separatorBuilder: (BuildContext context, int index)
                      => const Divider(height: 0, indent: 60, endIndent: 20,)
                  ),
            ),
          Padding(
            padding: const EdgeInsets.only(
                left: AppSpacing.xlg
            ),
            child: AppTextButton(
              text: 'Add payment',
              onPressed: () => showAppModal(
                context: context,
                content: const AddPaymentModal(),
              )
            ),
          )
        ],
      ),
    );
  }
}