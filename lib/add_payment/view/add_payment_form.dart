import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/add_payment/cubit/add_payment_cubit.dart';
import 'package:form_inputs/form_inputs.dart';

class AddPaymentForm extends StatefulWidget {
  const AddPaymentForm({
    super.key,
  });

  @override
  State<AddPaymentForm> createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends State<AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  final _causeController = TextEditingController();

  final _dateController = TextEditingController(text: DateTime.now().dMY);

  int sheet = 1;

  int paymentMethod = 1;

  int formulaSelected = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AddPaymentCubit>();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const Divider(
              endIndent: 0,
              indent: 0,
              height: 20,
            ),
            Wrap(children: [
              ChoiceChip(
                label: const Text('Manual'),
                labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                selectedColor: AppColors.primaryLight.withOpacity(0.4),
                side: BorderSide.none,
                padding: const EdgeInsets.all(4),
                selected: sheet == 1,
                onSelected: (_) {
                  setState(() {
                    sheet = 1;
                  });
                },
              ),
              const SizedBox(width: 4),
              ChoiceChip(
                label: const Text('Formula'),
                labelStyle: TextStyle(color: Colors.deepPurple.shade900),
                selectedColor: AppColors.primaryLight.withOpacity(0.4),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(4),
                selected: sheet == 2,
                onSelected: (_) {
                  setState(() {
                    sheet = 2;
                  });
                },
              ),
            ]),
            sheet == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextFormField(
                        label: 'Amount',
                        controller: _amountController,
                        prefix: const Icon(FeatherIcons.dollarSign, size: 21),
                        bottomText: 'Insert the amount of the transaction',
                        validator: (value) =>
                            bloc.state.amount.validator(value ?? '')?.text,
                      ),
                      const SizedBox(height: 10),
                      AppTextFormField(
                        label: 'Cause',
                        controller: _causeController,
                        bottomText: 'Insert the cause of the transaction',
                        validator: (value) =>
                            bloc.state.cause.validator(value ?? '')?.text,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Wrap(children: [
                        ChoiceChip(
                          label: Assets.images.paymentSepa.svg(),
                          surfaceTintColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          selectedColor: Colors.transparent,
                          side: paymentMethod == 1
                              ? const BorderSide(color: AppColors.primary)
                              : BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          selected: paymentMethod == 1,
                          onSelected: (_) {
                            setState(() {
                              paymentMethod = 1;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Assets.images.paymentMastercard.svg(),
                          surfaceTintColor: Colors.white,
                          selectedColor: Colors.transparent,
                          side: paymentMethod == 2
                              ? const BorderSide(color: AppColors.primary)
                              : BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          selected: paymentMethod == 2,
                          onSelected: (_) {
                            setState(() {
                              paymentMethod = 2;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: Assets.images.paymentCash.svg(),
                          surfaceTintColor: Colors.white,
                          selectedColor: Colors.transparent,
                          side: paymentMethod == 3
                              ? const BorderSide(color: AppColors.primary)
                              : BorderSide.none,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          selected: paymentMethod == 3,
                          onSelected: (_) {
                            setState(() {
                              paymentMethod = 3;
                            });
                          },
                        ),
                      ]),
                      AppTextFormField(
                        label: 'Date',
                        controller: _dateController,
                        prefix: const Icon(FeatherIcons.calendar, size: 21),
                        bottomText: 'Insert the date of the transaction',
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _dateController.text = date.dMY;
                          }
                        },
                        validator: (value) =>
                            bloc.state.date.validator(value ?? '')?.text,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      bloc.state.formula == null
                          ? Center(
                              heightFactor: 1.2,
                              child: Column(
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFF9FAFB),
                                          Color(0xFFEDF0F3)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Icon(
                                      FeatherIcons.dollarSign,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No formula found',
                                    style: TextStyle(
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: Color(0xFF101828),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "The athlete doesn't have been assigned to any payment formula",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        color: Color(0xFF475467),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white,
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                            color: Color(0xFFE4E7EC),
                                            width: 0.5)),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 6),
                                      horizontalTitleGap: 8,
                                      visualDensity: VisualDensity.compact,
                                      leading: Checkbox(
                                        value: formulaSelected == 1,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            formulaSelected = 1;
                                          });
                                        },
                                        activeColor: Colors.deepPurpleAccent,
                                        side: const BorderSide(
                                            color: Color(0xFFD0D5DD),
                                            width: 0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      title: const Text('Quota 1'),
                                      subtitle: Text(
                                          '\$${bloc.state.formula!.quota1} before ${bloc.state.formula!.date1.dMY}'),
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
                                    ),
                                  ),
                                  bloc.state.formula!.full
                                      ? const SizedBox.shrink()
                                      : Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          color: Colors.white,
                                          surfaceTintColor: Colors.white,
                                          elevation: 0.5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: const BorderSide(
                                                  color: Color(0xFFE4E7EC),
                                                  width: 0.5)),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 6),
                                            horizontalTitleGap: 8,
                                            visualDensity:
                                                VisualDensity.compact,
                                            leading: Checkbox(
                                              value: formulaSelected == 2,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  formulaSelected = 2;
                                                });
                                              },
                                              activeColor:
                                                  Colors.deepPurpleAccent,
                                              side: const BorderSide(
                                                  color: Color(0xFFD0D5DD),
                                                  width: 0.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            title: const Text('Quota 2'),
                                            subtitle: Text(
                                                '\$${bloc.state.formula!.quota2} before ${bloc.state.formula!.date2!.dMY}'),
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
                                          ),
                                        ),
                                  const Divider(
                                    height: 30,
                                  ),
                                  Wrap(children: [
                                    ChoiceChip(
                                      label: Assets.images.paymentSepa.svg(),
                                      surfaceTintColor: Colors.transparent,
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.transparent,
                                      side: paymentMethod == 1
                                          ? const BorderSide(
                                              color: AppColors.primary)
                                          : BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: EdgeInsets.zero,
                                      labelPadding: EdgeInsets.zero,
                                      selected: paymentMethod == 1,
                                      onSelected: (_) {
                                        setState(() {
                                          paymentMethod = 1;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    ChoiceChip(
                                      label:
                                          Assets.images.paymentMastercard.svg(),
                                      surfaceTintColor: Colors.white,
                                      selectedColor: Colors.transparent,
                                      side: paymentMethod == 2
                                          ? const BorderSide(
                                              color: AppColors.primary)
                                          : BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: EdgeInsets.zero,
                                      labelPadding: EdgeInsets.zero,
                                      selected: paymentMethod == 2,
                                      onSelected: (_) {
                                        setState(() {
                                          paymentMethod = 2;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    ChoiceChip(
                                      label: Assets.images.paymentCash.svg(),
                                      surfaceTintColor: Colors.white,
                                      selectedColor: Colors.transparent,
                                      side: paymentMethod == 3
                                          ? const BorderSide(
                                              color: AppColors.primary)
                                          : BorderSide.none,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: EdgeInsets.zero,
                                      labelPadding: EdgeInsets.zero,
                                      selected: paymentMethod == 3,
                                      onSelected: (_) {
                                        setState(() {
                                          paymentMethod = 3;
                                        });
                                      },
                                    ),
                                  ]),
                                ])
                    ],
                  ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    onPressed: () async {
                      final String cause;
                      final num amount;
                      final PaymentMethod method;
                      if (sheet == 1) {
                        if (!_formKey.currentState!.validate()) return;
                        cause = _causeController.text;
                        amount = double.parse(_amountController.text);
                        method = paymentMethod == 1
                            ? PaymentMethod.transfer
                            : paymentMethod == 2
                                ? PaymentMethod.other
                                : PaymentMethod.cash;
                      } else {
                        cause = bloc.state.formula!.name;
                        amount = formulaSelected == 1
                            ? bloc.state.formula!.quota1
                            : bloc.state.formula!.quota2!;
                        method = paymentMethod == 1
                            ? PaymentMethod.transfer
                            : paymentMethod == 2
                                ? PaymentMethod.other
                                : PaymentMethod.cash;
                      }
                      await bloc
                          .addPayment(
                              cause: cause,
                              amount: amount.toDouble(),
                              type: amount > 0
                                  ? PaymentType.income
                                  : PaymentType.expense,
                              method: method)
                          .then((_) => Navigator.of(context).pop());
                    },
                    child: bloc.state.status == FormzSubmissionStatus.inProgress
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.white,
                              strokeCap: StrokeCap.round,
                            ),
                          )
                        : const Text('Add'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
