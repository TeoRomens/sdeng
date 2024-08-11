import 'package:app_ui/app_ui.dart'
    show AppSpacing, AppTextButton, LoadingBox, showAppModal;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';
import 'package:sdeng/payment_formula/payment_formula.dart';
import 'package:sdeng/add_payment_formula/view/add_payment_formula_modal.dart';
import 'package:sdeng/edit_payment_formula/view/edit_payment_formula_modal.dart';

class PaymentFormulaPage extends StatelessWidget {
  const PaymentFormulaPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(builder: (_) => const PaymentFormulaPage());
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Payment Formulas',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
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
                    itemBuilder: (context, index) => PaymentFormulaItem(
                      title: paymentsFormulas[index].name,
                      trailing: IconButton(
                          onPressed: () => showAppModal(
                                context: context,
                                content: EditPaymentFormulaModal(
                                  paymentFormula: paymentsFormulas[index],
                                ),
                              ),
                          icon: const Icon(FeatherIcons.edit2)),
                    ),
                  );
                }
              }),
              AppTextButton(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                text: 'Payment Formula',
                onPressed: () async => await showAppModal(
                  context: context,
                  content: const AddPaymentFormulaModal(),
                ).then((_) =>
                    context.read<PaymentFormulaCubit>().getPaymentFormulas()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class PaymentFormulasTitle extends StatelessWidget {
  const PaymentFormulasTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        'Payment Formulas',
        style: theme.textTheme.headlineLarge,
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
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
