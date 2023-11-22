import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/globals/colors.dart';
import 'package:sdeng/globals/variables.dart';
import 'package:sdeng/ui/add_athlete/bloc/add_athlete_bloc.dart';

class AddAthleteForm extends StatefulWidget{
  const AddAthleteForm({super.key, required this.teamId});

  final String teamId;

  @override
  State<AddAthleteForm> createState() => _AddAthleteFormState();
}

class _AddAthleteFormState extends State<AddAthleteForm> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAthleteBloc, AddAthleteState>(
      builder: (context, state) {
        return Stepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            int lastStep = 3;
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(state.currentStep != lastStep)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStep++;
                      });
                    },
                    child: const Text('Continue'),
                  ),
                const SizedBox(width: 12,),
                if(currentStep == lastStep)
                  ElevatedButton(
                    onPressed: () {
                      context.read<AddAthleteBloc>().submitted(widget.teamId);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff48bb34)),
                    ),
                    child: const Text('Add Athlete'),
                  ),
                const SizedBox(width: 12,),
                if(currentStep != 0)
                  ElevatedButton(
                    onPressed: () {
                      if(currentStep != 0) {
                        setState(() {
                          currentStep--;
                        });
                      }
                    },
                    child: const Text('Back'),
                  ),
              ],
            );
          },
          onStepTapped: (int tapped) => setState(() {
            currentStep = tapped;
          }),
          steps: <Step>[
            Step(
              title: const Text('Dati Anagrafici'),
              isActive: currentStep >= 0,
              content: Form(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: (value) {
                          context.read<AddAthleteBloc>().nameChanged(value);
                        },
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Name'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().surnameChanged(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Surname'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().bornCityChanged(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Born City'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().addressChanged(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Address'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().cityChanged(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'City'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().taxIdChanged(value.toUpperCase());
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
                        decoration: const InputDecoration(hintText: 'Fiscal Code'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().phoneChanged(value);
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
                        decoration: const InputDecoration(hintText: 'Athlete\'s Phone'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().emailChanged(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Athlete\'s Email'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: ((value) {
                                context.read<AddAthleteBloc>().numberChanged(value);
                              }),
                              decoration: const InputDecoration(
                                  hintText: 'Jersey'),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: TextButton(
                              onPressed: () async {
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
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
                                  context.read<AddAthleteBloc>().birthDayChanged(selectedDate);
                                }
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  fixedSize: Size(MediaQuery.of(context).size.width / 2.8, 55),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: MyColors.primaryColor),
                                      borderRadius: BorderRadius.circular(16)
                                  )
                              ),
                              child: Text(
                                  state.birthDay != null ? '${state.birthDay!.day}/${state.birthDay!.month}/${state.birthDay!.year}' : 'Birth Day'
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: ((value) {
                                context.read<AddAthleteBloc>().heightChanged(value);
                              }),
                              decoration: const InputDecoration(
                                  hintText: 'Height',
                                  suffixText: 'cm'
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: ((value) {
                                context.read<AddAthleteBloc>().weightChanged(value);
                              }),
                              decoration: const InputDecoration(
                                  hintText: 'Weight',
                                  suffixText: 'kg'
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox( height: 30,),
                  ],
                ),
              ),
            ),
            Step(
              title: const Text('Parent Data'),
              isActive: currentStep >= 1,
              content: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().parentName(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Name'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().parentSurname(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Surname'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().parentEmail(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Email'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().parentPhone(value);
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Phone'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        onChanged: ((value) {
                          context.read<AddAthleteBloc>().parentTaxId(value.toUpperCase());
                        }),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Fiscal Code'),
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
              isActive: currentStep >= 2,
              content: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: SwitchListTile(
                          title: const Text('Rata Unica'),
                          activeColor: Colors.green,
                          value: state.rataUnica,
                          onChanged: (bool value) {
                            context.read<AddAthleteBloc>().rataSwitchChanged(value);
                          }
                      ),
                    ),
                    BlocBuilder<AddAthleteBloc, AddAthleteState>(
                        builder: (context, state) {
                          if(state.rataUnica){
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: TextFormField(
                                  onChanged: ((value) {
                                    context.read<AddAthleteBloc>().primaRataChanged(value);
                                  }),
                                  initialValue: state.primaRata.toString(),
                                  validator: (value) {
                                    if(value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
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
                                        context.read<AddAthleteBloc>().primaRataChanged(value);
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
                                      context.read<AddAthleteBloc>().secondaRataChanged(value);
                                    }),
                                    validator: (value) {
                                      if(!state.rataUnica && (value == null || value.isEmpty)) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
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
            Step(
              title: const Text('Visita Medica'),
              isActive: currentStep >= 3,
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: Color(0xff004aad)
                                  ),
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
                            context.read<AddAthleteBloc>().expiringDateChanged(selectedDate);
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            fixedSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xff004aad)),
                                borderRadius: BorderRadius.circular(16)
                            )
                        ),
                        child: Text(
                          state.expiringDate != null ? '${state.expiringDate!.day}/${state.expiringDate!.month}/${state.expiringDate!.year}' : 'Expiring Date',
                          style: const TextStyle(
                              color: Color(0xff004aad)
                          ),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      BlocBuilder<AddAthleteBloc, AddAthleteState>(
                          builder: (context, state) {
                            if(state.uploadStatus == UploadStatus.idle){
                              return ElevatedButton.icon(
                                  onPressed: () async {
                                    var pickedFile = await FilePicker.platform.pickFiles();
                                    if(pickedFile != null) context.read<AddAthleteBloc>().upload(pickedFile.files.first);
                                  },
                                  icon: const Icon(Icons.arrow_upward_rounded),
                                  label: const Text('Upload')
                              );
                            } else {
                              return ElevatedButton.icon(
                                onPressed: () async {
                                  var pickedFile = await FilePicker.platform.pickFiles();
                                  if(pickedFile != null) context.read<AddAthleteBloc>().upload(pickedFile.files.first);
                                },
                                icon: const Icon(Icons.arrow_upward_rounded),
                                label: const Text(
                                  'Upload Fail',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent.shade100,
                                ),
                              );
                            }
                          }
                      )
                    ],
                  ),
                  const SizedBox(height: 25,)
                ],
              ),
            )
          ],
        );
      }
    );
  }

  bool checkTaxId(String codiceFiscale) {
    if (codiceFiscale.length != 16) {
      return false;
    }
    return true;
  }
}