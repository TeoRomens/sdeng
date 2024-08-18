import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';
import 'package:sdeng/edit_payment_formula/view/edit_payment_formula_form.dart';

/// A modal that provides a form for editing a payment formula.
///
/// This widget wraps the [EditPaymentFormulaForm] in a [BlocProvider] to provide
/// the necessary [PaymentFormulaCubit] for managing the state of the form.
class EditPaymentFormulaModal extends StatelessWidget {
  /// Creates an instance of [EditPaymentFormulaModal].
  ///
  /// The [paymentFormula] parameter is required and represents the payment formula
  /// entity to be edited.
  const EditPaymentFormulaModal({
    super.key,
    required this.paymentFormula,
  });

  /// The payment formula entity to be edited.
  final PaymentFormula paymentFormula;

  /// Creates a route to navigate to the [EditPaymentFormulaModal].
  ///
  /// This method is used to create a [MaterialPageRoute] with the given
  /// [paymentFormula].
  static Route<void> route(PaymentFormula paymentFormula) =>
      MaterialPageRoute<void>(
          builder: (_) =>
              EditPaymentFormulaModal(paymentFormula: paymentFormula));

  /// The route name for this modal.
  static const String name = '/editPaymentFormulaModal';

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
