import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/cubits/payments_cubit.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/utils/constants.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({Key? key}) : super(key: key);

  /// Method ot create this page with necessary `BlocProvider`
  static Widget create() {
    return BlocProvider<PaymentsCubit>(
      create: (context) =>
      PaymentsCubit(
        repository: RepositoryProvider.of<Repository>(context),
      )
        ..loadPayments(),
      child: const PaymentsTab(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsCubit, PaymentsState>(
      builder: (context, state) {
        if (state is PaymentsLoading) {
          return preloader;
        } else if (state is PaymentsLoaded) {
          return PaymentList(
            payments: state.payments,
          );
        } else if (state is PaymentsError) {
          return const Center(child: Text('Something went wrong'));
        }
        throw UnimplementedError();
      },
    );
  }
}

/// Main view of Payments.
@visibleForTesting
class PaymentList extends StatefulWidget {
  /// Main view of Payments.
  PaymentList({
    Key? key,
    List<Payment>? payments,
  })  : _payments = payments ?? [],
        super(key: key);

  final List<Payment> _payments;

  @override
  PaymentPageState createState() => PaymentPageState();
}

@visibleForTesting
class PaymentPageState extends State<PaymentList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PaymentsCubit>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacer16,
        Text(
          'PAYMENTS',
          style: GoogleFonts.bebasNeue(
              fontSize: 60,
              color: black2,
              height: 0.85
          )
        ),
        spacer16,
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      label: const Text('Cashed'),
                      labelStyle: const TextStyle(color: greenColor),
                      labelPadding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: greenColor, width: 0.5),

                    ),
                    const Text('Saldo', style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total', style: TextStyle(
                      fontSize: 16,
                      color: black2
                    ),),
                    const SizedBox(height: 12),
                    Text('€ ${bloc.getTotal().toInt().toString()}', style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ],
            ),
          ),
        ),
        spacer16,
        ListTile(
          leading: const Icon(FeatherIcons.file, color: black2,),
          title: const Text('Receipts',),
          trailing: const Icon(FeatherIcons.chevronRight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xffcccccc), width: 0.8),
          ),
        ),
        spacer16,
        ListTile(
          tileColor: Colors.white,
          leading: const Icon(FeatherIcons.file, color: black2,),
          title: const Text('Transactions',),
          trailing: const Icon(FeatherIcons.chevronRight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xffcccccc), width: 0.8),
          ),
        ),
      ],
    );
  }
}

/*
class _NewPaymentDialogState extends State<NewPaymentDialog> {
  final _formKey = GlobalKey<FormState>();

  Athlete? athlete;
  final causeController = TextEditingController();
  final amountController = TextEditingController();
  PaymentType paymentType = PaymentType.income;
  PaymentMethod paymentMethod = PaymentMethod.transfer;

  _buildTypeChoiceList() {
    List<Widget> choices = [];
    choices.add(
      ChoiceChip(
        label: Text('Income', style: TextStyle(
          color: paymentType == PaymentType.income ? const Color(0xff24b47e) : Colors.grey,
        ),),
        selectedColor: const Color(0xffebf8f3),
        selected: paymentType == PaymentType.income,
        onSelected: (bool newValue) {
          setState(() {
            paymentType = PaymentType.income;
          });
        },
      )
    );
    choices.add(
      ChoiceChip(
        label: Text('Expense', style: TextStyle(
          color: paymentType == PaymentType.expense ? const Color(0xffef4444) : Colors.grey,
        ),),
        selectedColor: const Color(0xfffdeaea),
        selected: paymentType == PaymentType.expense,
        onSelected: (bool newValue) {
          setState(() {
            paymentType = PaymentType.expense;
          });
        },
      ),
    );
    return choices;
  }

  _buildMethodChoiceList() {
    List<Widget> choices = [];
    choices.add(
        ChoiceChip(
          label: Text('Cash', style: TextStyle(
            color: paymentMethod == PaymentMethod.cash ? Colors.blueAccent.shade700 : Colors.grey,
          ),),
          selectedColor: Colors.blue.shade100,
          selected: paymentMethod == PaymentMethod.cash,
          onSelected: (bool newValue) {
            setState(() {
              paymentMethod = PaymentMethod.cash;
            });
          },
        )
    );
    choices.add(
      ChoiceChip(
        label: Text('Transfer', style: TextStyle(
          color: paymentMethod == PaymentMethod.transfer ? Colors.blueAccent.shade700 : Colors.grey,
        ),),
        selectedColor: Colors.blue.shade100,
        selected: paymentMethod == PaymentMethod.transfer,
        onSelected: (bool newValue) {
          setState(() {
            paymentMethod = PaymentMethod.transfer;
          });
        },
      ),
    );
    choices.add(
      ChoiceChip(
        label: Text('Other', style: TextStyle(
          color: paymentMethod == PaymentMethod.other ? Colors.blueAccent.shade700 : Colors.grey,
        ),),
        selectedColor: Colors.blue.shade100,
        selected: paymentMethod == PaymentMethod.other,
        onSelected: (bool newValue) {
          setState(() {
            paymentMethod = PaymentMethod.other;
          });
        },
      ),
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AthletesCubit, AthletesState>(
        listener: (context, state) {
          if(state is AthletesError) {
            context.showSnackBar(message: state.error);
            Navigator.of(context).pop();
          }
        },
        builder: (context, athleteState) {
          return BlocConsumer<StaffCubit, StaffState>(
              listener: (context, state) {
                if(state is StaffError) {
                  context.showSnackBar(message: state.error);
                  Navigator.of(context).pop();
                }
              },
              builder: (context, staffState) {
                /// DropDownMenuEntries non loaded
                if(athleteState is AthletesInitial || staffState is StaffInitial) {
                  return preloader;
                }
                /// DropDownMenuEntries loaded correctly
                else if(athleteState is AthletesLoaded && staffState is StaffLoaded) {

                  //Create List DropdownMenuEntry
                  final List<DropdownMenuEntry<Person?>> staffs = staffState.staff.values.map((staff) =>
                      DropdownMenuEntry<Person?>(
                          value: staff,
                          label: staff!.fullName,
                          leadingIcon: const Icon(Icons.person, color: Colors.red,)
                      )
                  ).toList();
                  final List<DropdownMenuEntry<Person?>> athletes = athleteState.athletes.values.map((athlete) =>
                      DropdownMenuEntry<Person?>(
                          value: athlete,
                          label: athlete!.fullName
                      )
                  ).toList();
                }
                throw UnimplementedError();
              }
          );
        }
    );
  }

}

return ConstrainedBox(
  constraints: BoxConstraints(
      minWidth: MediaQuery.of(context).size.width * 0.85,
      maxWidth: 400
  ),
  child: Material(
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacer16,
          const Text('New Payment', style: TextStyle(
              inherit: false,
              fontSize: 26,
              color: Colors.black
          ),),
          spacer16,
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Type',
              style: TextStyle(
                color: Color(0xff686f75),
                fontSize: 16,
              ),
            ),
          ),
          Wrap(
              spacing: 8.0,
              children: _buildTypeChoiceList()
          ),
          spacer16,
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Owner',
              style: TextStyle(
                color: Color(0xff686f75),
                fontSize: 16,
              ),
            ),
          ),
          DropdownMenu<Person?>(
              hintText: 'Owner',
              onSelected: (value) =>
                  setState(() {
                    athlete = value;
                  }),
              trailingIcon: SvgPicture.asset('assets/icons/chevron-right.svg'),
              selectedTrailingIcon: SvgPicture.asset('assets/icons/chevron-down.svg'),
              dropdownMenuEntries: athletes + staffs
          ),
          spacer16,
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Cause',
              style: TextStyle(
                color: Color(0xff686f75),
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            controller: causeController,
            decoration: const InputDecoration(
              label: Text('Example: \'Prima Rata\''),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          spacer16,
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Amount',
              style: TextStyle(
                color: Color(0xff686f75),
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text(''),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          spacer16,
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Method',
              style: TextStyle(
                color: Color(0xff686f75),
                fontSize: 16,
              ),
            ),
          ),
          Wrap(
              spacing: 8.0,
              children: _buildMethodChoiceList()
          ),
          spacer16,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SdengDefaultButton(
                  text: 'Cancel',
                  onPressed: () {
                    causeController.dispose();
                    Navigator.of(context).pop();
                  }
              ),
              const SizedBox(width: 10,),
              SdengPrimaryButton(
                  text: 'Confirm',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await BlocProvider.of<PaymentsCubit>(context).addPayment(
                          taxCode: athlete!.taxCode,
                          cause: causeController.text,
                          amount: int.parse(amountController.text),
                          paymentType: paymentType,
                          paymentMethod: paymentMethod
                      );
                      Navigator.of(context).pop();
                    }
                  }
              )
            ],
          )
        ],
      ),
    ),
  ),
);
*/