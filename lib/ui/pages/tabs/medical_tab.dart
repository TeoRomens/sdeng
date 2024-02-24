import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/cubits/athletes_cubit.dart';
import 'package:sdeng/cubits/medical_cubit.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:sdeng/utils/formatter.dart';

class MedicalPage extends StatefulWidget {
  const MedicalPage({Key? key, this.initialIndex}) : super(key: key);

  static Widget create({int? initialIndex}) {
    return BlocProvider(
      create: (context) => MedicalCubit(
        repository: RepositoryProvider.of<Repository>(context),
      )..loadMedicals(),
      child: const MedicalPage(),
    );
  }

  final int? initialIndex;

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _newMedicalModal(BuildContext context) {
    final dateController = TextEditingController();
    Athlete? athlete;
    DateTime? expireDate;

    showDialog(
      context: context,
        builder: (dialogContext) => BlocConsumer<AthletesCubit, AthletesState>(
          listener: (context, state) {
            if(state is AthletesError) {
              context.showSnackBar(message: state.error);
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if(state is AthletesInitial) {
              return preloader;
            }
            else if(state is AthletesLoaded) {
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
                        const Text('New Medical Visit', style: TextStyle(
                            inherit: false,
                            fontSize: 26,
                            fontFamily: 'ProductSans',
                            color: Colors.black
                        ),),
                        spacer16,
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Athlete',
                            style: TextStyle(
                              color: Color(0xff686f75),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        DropdownMenu<Athlete?>(
                            hintText: '',
                            onSelected: (value) =>
                                setState(() {
                                  athlete = value;
                                }),
                            trailingIcon: SvgPicture.asset('assets/icons/chevron-right.svg'),
                            selectedTrailingIcon: SvgPicture.asset('assets/icons/chevron-down.svg'),
                            dropdownMenuEntries: state.athletes.values.map((athlete) =>
                                DropdownMenuEntry<Athlete?>(
                                    value: athlete,
                                    label: athlete!.fullName
                                )
                            ).toList()
                        ),
                        spacer16,
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Expire date',
                            style: TextStyle(
                              color: Color(0xff686f75),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: dateController,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            label: Text('01/06/2024'),
                          ),
                          onTap: () {
                            dateController.selection = TextSelection.fromPosition(
                              TextPosition(offset: dateController.text.length),
                            );
                          },
                          onChanged: (String value) {
                            expireDate = Formatter.type1(value, dateController);
                          },
                          validator: (val) {
                            if (expireDate!.isBefore(DateTime.now())) {
                              return 'Expire date must be a future date';
                            }
                            return null;
                          },
                        ),
                        spacer16,
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Optional',
                            style: TextStyle(
                              color: Color(0xff686f75),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SdengDefaultButton.icon(
                            text: 'Upload file',
                            icon: SvgPicture.asset('assets/icons/pdf.svg'),
                            onPressed: () {

                            }
                        ),
                        spacer16,
                        spacer16,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SdengDefaultButton(
                                text: 'Cancel',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                            ),
                            const SizedBox(width: 10,),
                            SdengPrimaryButton(
                                text: 'Confirm',
                                onPressed: () async {
                                  if(athlete == null) {
                                    context.showErrorSnackBar(message: 'Select an athlete');
                                    return;
                                  }
                                  if(_formKey.currentState!.validate()) {
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
            }
            throw UnimplementedError();
          }
        )
    );
  }

  Widget noDataText = const Center(
    child: Text('No Data', style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
    ),),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer16,
            const Text('MEDICAL VISITS', style: TextStyle(
                fontSize: 32
            ),),
            spacer16,
          ],
        ),
    );
  }
}