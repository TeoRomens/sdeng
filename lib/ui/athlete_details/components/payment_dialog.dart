import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/athlete_details/bloc/athlete_bloc.dart';
import 'package:sdeng/util/message_util.dart';

enum PaymentType {
  first,
  second,
}

class PaymentDialog extends StatefulWidget{
  const PaymentDialog(this.context, {super.key});

  final BuildContext context;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String selectedChoice = "first-payment";
  String? amount;
  DateTime? date;

  _buildChoiceList() {
    List<Widget> choices = [];
    choices.add(
      ChoiceChip(
        label: const Text('First Rata'),
        selected: selectedChoice == "first-payment",
        onSelected: (selected) {
          setState(() {
            selectedChoice = "first-payment";
          });
        },
      )
    );
    choices.add(
        ChoiceChip(
          label: const Text('Second Rata'),
          selected: selectedChoice == "second-payment",
          onSelected: (selected) {
            setState(() {
              selectedChoice = "second-payment";
            });
          },
        )
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add payment',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            children: _buildChoiceList(),
          ),
          Form(
            key: key,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  InputDatePickerFormField(
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime(2050),
                    onDateSaved: (value) {
                      date = value;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Amount',
                        suffixText: '€'
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onSaved: (value) {
                      amount = value;
                    },
                    validator: (value) {
                      if(value == null) return 'Insert a value';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () async {
              key.currentState?.save();
              if(key.currentState?.validate() ?? false) {
                MessageUtil.showLoading();
                await widget.context.read<AthleteBloc>().addPayment(amount: amount!, date: date!, type: PaymentType.first);
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                  color: Colors.white
              ),
            )
        )
      ],
    );
  }
}