import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/cubits/payments_cubit.dart';
import 'package:sdeng/model/payment.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/formatter.dart';

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({Key? key}) : super(key: key);

  static Widget create() {
    return BlocProvider<PaymentsCubit>(
      create: (context) => PaymentsCubit(
        repository: RepositoryProvider.of<Repository>(context),
      )..loadPayments(),
      child: const PaymentsTab(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer16,
              SdengPrimaryButton(
                  text: 'New Payment',
                  onPressed: () {
                    // TODO: Implement new payment process
                  }
              ),
              spacer16,
              const Text('Payments', style: TextStyle(
                  fontSize: 26
              ),),
              spacer16,
              BlocConsumer<PaymentsCubit, PaymentsState>(
                listener: (context, state) {
                  if (state is PaymentsError) {
                    context.showErrorSnackBar(message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is PaymentsInitial) {
                    return preloader;
                  }
                  else if (state is PaymentsLoaded) {
                    final payments = state.payments;
                    return Column(
                      children: [
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: payments.length,
                          itemBuilder: (context, index) {
                            final payment = payments.elementAt(index);
                            return ListTile(
                              title: Text(payment.cause),
                              subtitle: Text(Formatter.readableDate(payment.createdAt)),
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(Radius.circular(4))
                                ),
                                width: 35,
                                height: 35,
                                child: Icon(Icons.monetization_on_outlined, color: Colors.grey.shade700,)
                              ),
                              trailing: Text('€ ${payment.amount.toStringAsFixed(2)}'),
                              leadingAndTrailingTextStyle: TextStyle(
                                color: payment.type == PaymentType.income ? Colors.green : Colors.red.shade600,
                                fontFamily: 'ProductSans',
                                fontSize: 20
                              ),
                              contentPadding: const EdgeInsets.only(left: 5, right: 5),
                              onTap: () {

                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 0,
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is PaymentsEmpty) {
                    return const Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text('Start adding your first payment!'),
                          ),
                        ),
                      ],
                    );
                  }
                  else if (state is PaymentsLoading) {
                    return preloader;
                  }
                  throw UnimplementedError();
                },
              ),
            ],
          ),
        ),
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
              fontFamily: 'ProductSans',
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