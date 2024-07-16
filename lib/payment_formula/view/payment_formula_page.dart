import 'package:app_ui/app_ui.dart' show AppBackButton, AppColors, AppFontWeight, AppLogo, AppSpacing, AppSwitch, AppTextButton, LoadingBox, showAppModal;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';
import 'package:sdeng/payment_formula/payment_formula.dart';
import 'package:sdeng/payment_formula/view/add_payment_formula_modal.dart';
import 'package:sdeng/payment_formula/view/edit_payment_formula_modal.dart';

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
    final paymentsFormulas = context.select((PaymentFormulaCubit bloc) => bloc.state.paymentsFormulas);

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
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          surfaceTintColor: AppColors.transparent,
          leading: const AppBackButton(),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PaymentFormulasTitle(),
            BlocBuilder<PaymentFormulaCubit, PaymentFormulaState>(
              builder: (context, state) {
                if(state.status == PaymentFormulaStatus.loading){
                  return const LoadingBox();
                }
                else {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: paymentsFormulas.length,
                    itemBuilder: (context, index) =>
                        PaymentFormulaItem(
                          title: paymentsFormulas[index].name,
                          trailing: IconButton(
                              onPressed: () => showAppModal(
                                context: context,
                                content: EditPaymentFormulaModal(
                                  paymentFormula: paymentsFormulas[index],
                                ),
                              ),
                              icon: const Icon(FeatherIcons.edit2)
                          ),
                        ),
                    separatorBuilder: (context, index) =>
                    const _PaymentFormulaDivider(),
                  );
                }
              }
            ),
            AppTextButton(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              text: 'Payment Formula',
              onPressed: () async => await showAppModal(
                context: context,
                content: const AddPaymentFormulaModal(),
              ).then((_) => context.read<PaymentFormulaCubit>().getPaymentFormulas()),
            )
          ],
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

  static const _leadingWidth = AppSpacing.xxlg + AppSpacing.md;

  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        width: _leadingWidth,
        child: Icon(FeatherIcons.dollarSign),
      ),
      trailing: trailing,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      horizontalTitleGap: 0,
      minLeadingWidth: _leadingWidth,
      onTap: onTap,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge
    );
  }
}

class _PaymentFormulaDivider extends StatelessWidget {
  const _PaymentFormulaDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Divider(
        color: AppColors.borderOutline,
        height: AppSpacing.xs,
        indent: 0,
        endIndent: 0,
      ),
    );
  }
}


