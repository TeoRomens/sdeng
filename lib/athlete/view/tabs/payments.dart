import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/add_payment/view/add_payment_modal.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/payment_formula/payment_formula.dart';

class PaymentInfo extends StatelessWidget {
  const PaymentInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();

    final athlete = bloc.state.athlete;
    final payments = bloc.state.payments;
    final paymentFormula = bloc.state.paymentFormula;

    return bloc.state.status == AthleteStatus.loading
        ? const LoadingBox()
        : Padding(
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.lg
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Formula',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SecondaryButton(
                      onPressed: () async {

                      },
                      text: 'Edit',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                paymentFormula != null ?
                  Card(
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                            color: Color(0xFFE4E7EC),
                            width: 0.5
                        )
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5
                      ),
                      visualDensity: VisualDensity.compact,
                      title: Text(paymentFormula.name),
                      trailing: const Icon(FeatherIcons.chevronRight),
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
                      onTap: () => Navigator.of(context).push(PaymentFormulaPage.route()),
                    ),
                  )
                  : SecondaryButton(
                    icon: FeatherIcons.plus,
                    text: 'Assign',
                    onPressed: () {
                      //TODO
                    },
                  ),
                const SizedBox(height: AppSpacing.xlg,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent transactions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm,),
                payments.isNotEmpty ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SecondaryButton(
                        icon: FeatherIcons.plus,
                        text: 'Add payment',
                        onPressed: () {
                          showAppModal(
                            context: context,
                            content: AddPaymentModal(
                              athlete: athlete,
                              formula: paymentFormula,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context,index) => ListTile(
                          horizontalTitleGap: 16,
                          contentPadding: const EdgeInsets.only(
                            right: 10
                          ),
                          visualDensity: VisualDensity.compact,
                          leading: SizedBox(
                            height: 34,
                            child: payments[index].method == PaymentMethod.transfer
                                ? Assets.images.paymentSepa.svg()
                                : payments[index].method == PaymentMethod.cash
                                ? Assets.images.paymentCash.svg() : Assets.images.paymentMastercard.svg(),
                          ),
                          title: Text(payments[index].cause),
                          subtitle: Text(payments[index].createdAt.dMY),
                          trailing: payments[index].amount > 0
                              ? Text('+ \$${payments[index].amount.toString()}')
                              : Text('- \$${payments[index].amount.toString()}'),
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
                            color: payments[index].amount > 0 ? const Color(0xFF079455) : AppColors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                        separatorBuilder: (_, index) => const Divider(),
                        itemCount: payments.length
                      ),
                    ],
                  )
                  : EmptyState(
                      actionText: 'Add payment',
                      onPressed: () => showAppModal(
                        context: context,
                        content: AddPaymentModal(
                          athlete: athlete,
                          formula: paymentFormula,
                        )
                      ),
                  ),
            ],
        ),
      );
  }
}

