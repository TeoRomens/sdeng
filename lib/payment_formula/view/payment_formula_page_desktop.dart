import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';
import 'package:sdeng/payment_formula/payment_formula.dart';
import 'package:sdeng/add_payment_formula/view/add_payment_formula_modal.dart';
import 'package:sdeng/edit_payment_formula/view/edit_payment_formula_modal.dart';

class PaymentFormulaPageDesktop extends StatelessWidget {
  const PaymentFormulaPageDesktop({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const PaymentFormulaPageDesktop());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentFormulaCubit(
        paymentsRepository: context.read<PaymentsRepository>(),
      )..getPaymentFormulas(),
      child: const PaymentFormulaView(),
    );
  }
}

@visibleForTesting
class PaymentFormulaView extends StatefulWidget {
  const PaymentFormulaView({super.key});

  @override
  State<PaymentFormulaView> createState() => _PaymentFormulaViewState();
}

class _PaymentFormulaViewState extends State<PaymentFormulaView> {
  @override
  Widget build(BuildContext context) {
    final paymentsFormulas = context
        .select((PaymentFormulaCubit bloc) => bloc.state.paymentsFormulas);

    return BlocListener<PaymentFormulaCubit, PaymentFormulaState>(
      listener: (context, state) {
        if (state.status == PaymentFormulaStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error)),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Payments Formula \nSettings',
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              color: AppColors.pastelGrey.withOpacity(0.5),
              thickness: 1,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextBox(
                            title: 'Payments Formulas',
                            content:
                                'Here you can find all your payments formulas.'),
                        BlocBuilder<PaymentFormulaCubit, PaymentFormulaState>(
                            builder: (context, state) {
                          if (state.status == PaymentFormulaStatus.loading) {
                            return const LoadingBox();
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: paymentsFormulas.length,
                              itemBuilder: (context, index) =>
                                  PaymentFormulaItem(
                                title: paymentsFormulas[index].name,
                                trailing: IconButton(
                                    onPressed: () => showAppModal(
                                          context: context,
                                          content: EditPaymentFormulaModal(
                                            paymentFormula:
                                                paymentsFormulas[index],
                                          ),
                                        ),
                                    icon: const Icon(FeatherIcons.edit2)),
                              ),
                            );
                          }
                        }),
                        AppTextButton(
                          text: 'Payment Formula',
                          onPressed: () async => await showAppModal(
                            context: context,
                            content: const AddPaymentFormulaModal(),
                          ).then((_) => context
                              .read<PaymentFormulaCubit>()
                              .getPaymentFormulas()),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class PaymentFormulaItem extends StatelessWidget {
  const PaymentFormulaItem({
    required this.title,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE4E7EC), width: 0.5)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        visualDensity: VisualDensity.compact,
        title: Text(title),
        trailing: trailing,
        titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
            color: Colors.black,
            height: 1.6),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF475467),
        ),
        onTap: onTap,
      ),
    );
  }
}
