import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';

/// A form for editing a payment formula.
///
/// This widget provides a form to edit details of a payment formula and uses a BLoC (`PaymentFormulaCubit`) for state management.
class EditPaymentFormulaForm extends StatefulWidget {
  /// Creates an instance of [EditPaymentFormulaForm].
  ///
  /// The [paymentFormula] parameter is required and represents the payment formula entity to be edited.
  const EditPaymentFormulaForm({
    super.key,
    required this.paymentFormula,
  });

  /// The payment formula entity to be edited.
  final PaymentFormula paymentFormula;

  @override
  State<EditPaymentFormulaForm> createState() => _EditPaymentFormulaFormState();
}

class _EditPaymentFormulaFormState extends State<EditPaymentFormulaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amount1Controller = TextEditingController();
  final _amount2Controller = TextEditingController();
  final _date1Controller = TextEditingController();
  final _date2Controller = TextEditingController();
  bool full = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current payment formula values
    _nameController.text = widget.paymentFormula.name;
    _amount1Controller.text = widget.paymentFormula.quota1.toStringAsFixed(2);
    _amount2Controller.text =
        widget.paymentFormula.quota2?.toStringAsFixed(2) ?? '';
    _date1Controller.text = widget.paymentFormula.date1.dMY;
    _date2Controller.text = widget.paymentFormula.date2?.dMY ?? '';
    full = widget.paymentFormula.full;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<PaymentFormulaCubit>().state;

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xlg,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(
              'Edit payment formula',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            endIndent: 0,
            indent: 0,
            height: 25,
          ),
          AppTextFormField(
            label: 'Name',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextFormField(
            label: 'Quota 1',
            controller: _amount1Controller,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              try {
                num.parse(value);
              } catch (err) {
                return 'Only digits are accepted';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextFormField(
            label: 'To be paid before',
            controller: _date1Controller,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                _date1Controller.text = selectedDate.dMY;
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Single rata',
                style: UITextStyle.bodyLarge,
              ),
              Switch.adaptive(
                value: full,
                onChanged: (value) {
                  setState(() {
                    full = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!full) ...[
            AppTextFormField(
              label: 'Quota 2',
              controller: _amount2Controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                try {
                  num.parse(value);
                } catch (err) {
                  return 'Only digits are accepted';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextFormField(
              label: 'To be paid before',
              controller: _date2Controller,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  _date2Controller.text = selectedDate.dMY;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await context
                    .read<PaymentFormulaCubit>()
                    .updatePaymentFormula(
                  id: widget.paymentFormula.id,
                  name: _nameController.text,
                  full: full,
                  amount1: num.parse(_amount1Controller.text),
                  date1: _date1Controller.text.toDateTime!,
                  amount2: full ? null : num.parse(_amount2Controller.text),
                  date2: full ? null : _date2Controller.text.toDateTime!,
                )
                    .then((_) => Navigator.of(context).pop());
              }
            },
            child: state.status == PaymentFormulaStatus.loading
                ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.white,
                strokeCap: StrokeCap.round,
              ),
            )
                : const Text('Save'),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
