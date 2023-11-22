import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/parent.dart';
import 'package:sdeng/model/payment.dart';

import '../bloc/edit_athlete_bloc.dart';

class EditAthleteScreen extends StatelessWidget {
  const EditAthleteScreen({Key? key,
    required this.athlete,
    required this.parent,
    required this.payment,
  }) : super(key: key);

  final Athlete athlete;
  final Parent parent;
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final keyDati = GlobalKey<FormState>();
    final keyGenitore = GlobalKey<FormState>();
    final keyQuota = GlobalKey<FormState>();
    DateTime birthDay = athlete.birth.toDate();
    bool rataUnica = payment.rataUnica;

    return BlocProvider(
        create: (context) => EditAthleteBloc(),
        child: BlocListener<EditAthleteBloc, EditAthleteState>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Oh No!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            state.errorMessage!,
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              );
            }
            if (state.status == Status.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Lottie.asset('assets/animations/successful.json')
                    )
                ),
              );
              Navigator.of(context).pop();
            }
            if (state.status == Status.failure) {

            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Athlete'),
            ),
            body: BlocBuilder<EditAthleteBloc, EditAthleteState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    Stepper(
                      type: StepperType.vertical,
                      physics: const ScrollPhysics(),
                      currentStep: state.currentStep,
                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                        int lastStep = 2;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(state.currentStep != 0)
                              ElevatedButton(
                                onPressed: () {
                                  keyDati.currentState!.save();
                                  keyQuota.currentState!.save();
                                  if(state.currentStep != 0) {
                                    context.read<EditAthleteBloc>().add(StepChangedEvent(step: state.currentStep - 1));
                                  }
                                },
                                child: const Text('Back'),
                              ),
                            const SizedBox(width: 12,),
                            if(state.currentStep != lastStep)
                              ElevatedButton(
                                onPressed: () {
                                  switch(state.currentStep){
                                    case 0: {
                                      if(keyDati.currentState!.validate()) {
                                        context.read<EditAthleteBloc>().add(StepChangedEvent(step: state.currentStep + 1));
                                      }
                                      break;
                                    }
                                    case 1: {
                                      if(keyGenitore.currentState!.validate()) {
                                        context.read<EditAthleteBloc>().add(StepChangedEvent(step: state.currentStep + 1));
                                      }
                                      break;
                                    }
                                  }
                                },
                                child: const Text('Continue'),
                              ),
                            const SizedBox(width: 12,),
                            if(state.currentStep == lastStep)
                              ElevatedButton(
                                onPressed: () {
                                  if(keyGenitore.currentState!.validate() && keyDati.currentState!.validate() && keyQuota.currentState!.validate()) {
                                    context.read<EditAthleteBloc>().add(SubmittedEvent(athlete: athlete, parent: parent, payment: payment));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(
                                      0xff2c941d)),
                                ),
                                child: const Text('Update Athlete'),
                              ),
                          ],
                        );
                      },
                      onStepTapped: (int tapped) {
                          context.read<EditAthleteBloc>().add(StepChangedEvent(step: tapped));
                      },
                      steps: <Step>[
                        Step(
                          title: const Text('Dati Anagrafici'),
                          isActive: true,
                          content: Form(
                            key: keyDati,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(NameChanged(name: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.name,
                                    decoration: const InputDecoration(hintText: 'Name'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(SurnameChanged(surname: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.surname,
                                    decoration: const InputDecoration(hintText: 'Surname'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(BornCityChanged(bornCity: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.bornCity,
                                    decoration: const InputDecoration(hintText: 'Born City'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(AddressChanged(address: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.address,
                                    decoration: const InputDecoration(hintText: 'Address'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(CityChanged(city: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.city,
                                    decoration: const InputDecoration(hintText: 'City'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(TaxIdChanged(taxId: value.toUpperCase()));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      if(!checkTaxId(value)){
                                        return 'Enter a valid taxId';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.taxId,
                                    decoration: const InputDecoration(hintText: 'Fiscal Code'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(PhoneChanged(phone: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      if(value.length != 10) {
                                        return 'Insert a valid number';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.phone,
                                    decoration: const InputDecoration(hintText: 'Athlete\'s Phone'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(EmailChanged(email: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: athlete.email,
                                    decoration: const InputDecoration(hintText: 'Athlete\'s Email'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 2.8,
                                      height: 55,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        onChanged: ((value) {
                                          context.read<EditAthleteBloc>().add(NumberChanged(number: value));
                                        }),
                                        initialValue: athlete.number.toString(),
                                        decoration: const InputDecoration(
                                            hintText: 'Jersey',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 30,),
                                    TextButton(
                                      onPressed: () async {
                                        DateTime? selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: athlete.birth.toDate(),
                                          firstDate: DateTime(1930),
                                          lastDate: DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                textButtonTheme: TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if(selectedDate != null) {
                                          birthDay = selectedDate;
                                          context.read<EditAthleteBloc>().add(BirthdayChanged(date: selectedDate));
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          fixedSize: Size(MediaQuery.of(context).size.width / 2.8, 55),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(color: MyColors.primaryColorDark),
                                              borderRadius: BorderRadius.circular(16)
                                          )
                                      ),
                                      child: Text(
                                          '${birthDay.day}/${birthDay.month}/${birthDay.year}'
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15,),
                                const Divider(
                                  indent: 5,
                                  endIndent: 5,
                                  color: Colors.grey,
                                ),
                                const Text(
                                  'Optional',
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                const SizedBox(height: 15,),
                              ],
                            ),
                          ),
                        ),
                        Step(
                          title: const Text('Parent Data'),
                          isActive: true,
                          content: Form(
                            key: keyGenitore,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(ParentNameChanged(name: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: parent.name,
                                    decoration: const InputDecoration(hintText: 'Name'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(ParentSurnameChanged(surname: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: parent.surname,
                                    decoration: const InputDecoration(hintText: 'Surname'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(ParentEmailChanged(email: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: parent.email,
                                    decoration: const InputDecoration(hintText: 'Email'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(ParentPhoneChanged(phone: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    initialValue: parent.phone,
                                    decoration: const InputDecoration(hintText: 'Phone'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().add(ParentTaxIdChanged(taxId: value));
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: parent.taxId,
                                    decoration: const InputDecoration(hintText: 'Tax ID'),
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                const SizedBox( height: 30,),
                              ],
                            ),
                          ),
                        ),
                        Step(
                          title: const Text('Quota'),
                          isActive: true,
                          content: Form(
                            key: keyQuota,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: SwitchListTile(
                                      title: const Text('Rata Unica'),
                                      activeColor: Colors.green,
                                      value: rataUnica,
                                      onChanged: (bool value) {
                                        rataUnica = value;
                                        context.read<EditAthleteBloc>().add(RataSwitchChangedEvent(rataUnica: value));
                                      }
                                  ),
                                ),
                                BlocBuilder<EditAthleteBloc, EditAthleteState>(
                                    builder: (context, state) {
                                      if(rataUnica){
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width / 1.3,
                                            child: TextFormField(
                                              onChanged: ((value) {
                                                context.read<EditAthleteBloc>().add(PrimaRataChangedEvent(primaRata: value));
                                              }),
                                              validator: (value) {
                                                if(value == null || value.isEmpty) {
                                                  return 'This field is required';
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.number,
                                              initialValue: payment.amount.toString(),
                                              decoration: const InputDecoration(
                                                  hintText: 'Quota',
                                                  suffixText: '€'
                                              ),
                                              textInputAction: TextInputAction.next,
                                            ),
                                          ),
                                        );
                                      }
                                      else{
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width / 1.3,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.digitsOnly
                                                  ],
                                                  onChanged: ((value) {
                                                    context.read<EditAthleteBloc>().add(PrimaRataChangedEvent(primaRata: value));
                                                  }),
                                                  validator: (value) {
                                                    if(value == null || value.isEmpty) {
                                                      return 'This field is required';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: const InputDecoration(
                                                      hintText: 'Prima Rata',
                                                      suffixText: '€'
                                                  ),
                                                  initialValue: payment.primaRata.toString(),
                                                  textInputAction: TextInputAction.next,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15,),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.3,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly
                                                ],
                                                onChanged: ((value) {
                                                  context.read<EditAthleteBloc>().add(SecondaRataChangedEvent(secondaRata: value));
                                                }),
                                                initialValue: payment.secondaRata.toString(),
                                                decoration: const InputDecoration(
                                                    hintText: 'Seconda Rata',
                                                    suffixText: '€'
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 25,)
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: state.status == Status.submitting ? true : false,
                      child: ModalBarrier(
                        color: Colors.black.withOpacity(0.4),
                        dismissible: false,
                      ),
                    ),
                    Visibility(
                        visible: state.status == Status.submitting ? true : false,
                        child: Center(
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                            height: 120,
                          ),
                        )
                    )
                  ]
                );
              }
            ),
          ),
        )
    );
  }

  bool checkTaxId(String codiceFiscale) {
    if (codiceFiscale.length != 16) {
      return false;
    }
    if (!codiceFiscale.contains(RegExp(r"^[a-zA-Z0-9]+$"))) {
      return false;
    }
    return true;
  }
}
