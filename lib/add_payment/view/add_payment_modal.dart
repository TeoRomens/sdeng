import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/add_payment/cubit/add_payment_cubit.dart';
import 'package:sdeng/add_payment/view/add_payment_form.dart';

class AddPaymentModal extends StatelessWidget {
  const AddPaymentModal({super.key,
    this.athlete,
    this.formula
  });

  static Route<void> route(Athlete? athlete, PaymentFormula? formula) =>
      MaterialPageRoute<void>(builder: (_) => AddPaymentModal(
        athlete: athlete,
        formula: formula,
      ));

  static const String name = '/addPaymentModal';

  final Athlete? athlete;
  final PaymentFormula? formula;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddPaymentCubit(
        formula: formula,
        athlete: athlete,
        paymentsRepository: context.read<PaymentsRepository>(),
      ),
      child: const AddPaymentForm(),
    );
  }
}
