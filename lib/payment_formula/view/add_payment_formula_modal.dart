import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';
import 'package:sdeng/payment_formula/widgets/add_payment_formula_form.dart';

class AddPaymentFormulaModal extends StatelessWidget {
  const AddPaymentFormulaModal({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const AddPaymentFormulaModal());

  static const String name = '/addPaymentFormulaModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentFormulaCubit(
        paymentsRepository: context.read<PaymentsRepository>(),
      ),
      child: const AddPaymentFormulaForm(),
    );
  }
}
