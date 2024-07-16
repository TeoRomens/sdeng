import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';
import 'package:sdeng/payment_formula/widgets/edit_payment_formula_form.dart';

class EditPaymentFormulaModal extends StatelessWidget {
  const EditPaymentFormulaModal({super.key,
    required this.paymentFormula,
  });

  static Route<void> route(PaymentFormula paymentFormula) =>
      MaterialPageRoute<void>(builder: (_) => EditPaymentFormulaModal(
        paymentFormula: paymentFormula
      ));

  static const String name = '/editPaymentFormulaModal';

  final PaymentFormula paymentFormula;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentFormulaCubit(
        paymentsRepository: context.read<PaymentsRepository>(),
      ),
      child: EditPaymentFormulaForm(paymentFormula: paymentFormula),
    );
  }
}
