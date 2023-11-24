import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/parent.dart';

import '../bloc/edit_athlete_bloc.dart';

class EditAthleteScreen extends StatefulWidget {
  const EditAthleteScreen({Key? key,
    required this.athlete,
    required this.parent,
  }) : super(key: key);

  final Athlete athlete;
  final Parent parent;

  @override
  State<EditAthleteScreen> createState() => _EditAthleteScreenState();
}

class _EditAthleteScreenState extends State<EditAthleteScreen> {
  int currentStep = 0;
  
  @override
  Widget build(BuildContext context) {
    final keyDati = GlobalKey<FormState>();
    final keyParent = GlobalKey<FormState>();
    final keyQuota = GlobalKey<FormState>();
    DateTime birthDay = widget.athlete.birth.toDate();
    bool rataUnica = true;

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
                      currentStep: currentStep,
                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                        int lastStep = 2;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if(currentStep != 0)
                              ElevatedButton(
                                onPressed: () {
                                  keyDati.currentState!.save();
                                  keyQuota.currentState!.save();
                                  if(currentStep != 0) {
                                    setState(() {
                                      currentStep--;
                                    });
                                  }
                                },
                                child: const Text('Back'),
                              ),
                            const SizedBox(width: 12,),
                            if(currentStep != lastStep)
                              ElevatedButton(
                                onPressed: () {
                                  switch(currentStep){
                                    case 0: {
                                      if(keyDati.currentState!.validate()) {
                                        setState(() {
                                          currentStep++;
                                        });
                                      }
                                      break;
                                    }
                                    case 1: {
                                      if(keyParent.currentState!.validate()) {
                                        setState(() {
                                          currentStep++;
                                        });
                                      }
                                      break;
                                    }
                                  }
                                },
                                child: const Text('Continue'),
                              ),
                            const SizedBox(width: 12,),
                            if(currentStep == lastStep)
                              ElevatedButton(
                                onPressed: () {
                                  if(keyParent.currentState!.validate() && keyDati.currentState!.validate() && keyQuota.currentState!.validate()) {
                                    context.read<EditAthleteBloc>().submittedEventHandler(widget.athlete, widget.parent);
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
                        setState(() {
                          currentStep = tapped;
                        });
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
                                      context.read<EditAthleteBloc>().nameChangedEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.athlete.name,
                                    decoration: const InputDecoration(hintText: 'Name'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().surnameChangedEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.athlete.surname,
                                    decoration: const InputDecoration(hintText: 'Surname'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().bornCityChangedEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.athlete.bornCity,
                                    decoration: const InputDecoration(hintText: 'Born City'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().addressChangedEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.athlete.address,
                                    decoration: const InputDecoration(hintText: 'Address'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().cityChangedEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.athlete.city,
                                    decoration: const InputDecoration(hintText: 'City'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().taxIdChangedEventHandler(value);
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
                                    initialValue: widget.athlete.taxId,
                                    decoration: const InputDecoration(hintText: 'Fiscal Code'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().phoneChangedEventHandler(value);
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
                                    initialValue: widget.athlete.phone,
                                    decoration: const InputDecoration(hintText: 'Athlete\'s Phone'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().emailChangedEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.athlete.email,
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
                                          context.read<EditAthleteBloc>().numberChangedEventHandler(value);
                                        }),
                                        initialValue: widget.athlete.number.toString(),
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
                                          initialDate: widget.athlete.birth.toDate(),
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
                                          context.read<EditAthleteBloc>().birthDayChangedEventHandler(selectedDate);
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
                            key: keyParent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().parentNameEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.parent.name,
                                    decoration: const InputDecoration(hintText: 'Name'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().parentSurnameEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.parent.surname,
                                    decoration: const InputDecoration(hintText: 'Surname'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().parentEmailEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.parent.email,
                                    decoration: const InputDecoration(hintText: 'Email'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().parentPhoneEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    initialValue: widget.parent.phone,
                                    decoration: const InputDecoration(hintText: 'Phone'),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    onChanged: ((value) {
                                      context.read<EditAthleteBloc>().parentTaxIdEventHandler(value);
                                    }),
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    initialValue: widget.parent.taxId,
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
                                        setState(() {
                                          rataUnica = value;
                                        });
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
                                                context.read<EditAthleteBloc>().primaRataChangedEventHandler(value);
                                              }),
                                              validator: (value) {
                                                if(value == null || value.isEmpty) {
                                                  return 'This field is required';
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.number,
                                              initialValue: widget.athlete.amount.toString(),
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
                                                    context.read<EditAthleteBloc>().primaRataChangedEventHandler(value);
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
                                                  initialValue: widget.athlete.amount.toString(),
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
                                                  context.read<EditAthleteBloc>().secondaRataChangedEventHandler(value);
                                                }),
                                                initialValue: widget.athlete.amount.toString(),
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
