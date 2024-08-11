import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/payment_formula/bloc/payment_formula_cubit.dart';

class AddPaymentFormulaForm extends StatefulWidget {
  const AddPaymentFormulaForm({super.key});

  @override
  State<AddPaymentFormulaForm> createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends State<AddPaymentFormulaForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amount1Controller = TextEditingController();
  final _amount2Controller = TextEditingController();
  final _date1Controller = TextEditingController();
  final _date2Controller = TextEditingController();
  bool full = true;

  @override
  Widget build(BuildContext context) {
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
          const _ModalTitle(),
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
          const SizedBox(
            height: AppSpacing.sm,
          ),
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
          const SizedBox(
            height: AppSpacing.sm,
          ),
          AppTextFormField(
            label: 'To be paid before',
            prefix: const Icon(FeatherIcons.calendar),
            controller: _date1Controller,
            readOnly: true,
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
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
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
                  }),
            ],
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          full
              ? const SizedBox.shrink()
              : AppTextFormField(
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
          full
              ? const SizedBox.shrink()
              : const SizedBox(
                  height: AppSpacing.sm,
                ),
          full
              ? const SizedBox.shrink()
              : AppTextFormField(
                  label: 'To be paid before',
                  prefix: const Icon(FeatherIcons.calendar),
                  controller: _date2Controller,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    if (selectedDate != null) {
                      _date2Controller.text = selectedDate.dMY;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
          const SizedBox(
            height: AppSpacing.lg,
          ),
          PrimaryButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await BlocProvider.of<PaymentFormulaCubit>(context)
                    .addPaymentFormula(
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
            child: const Text('Add'),
          ),
          const SizedBox(
            height: AppSpacing.xlg,
          ),
        ],
      ),
    );
  }
}

class _ModalTitle extends StatelessWidget {
  const _ModalTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Text(
        'New payment formula',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
