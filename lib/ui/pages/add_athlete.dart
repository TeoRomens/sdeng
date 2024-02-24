import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/cubits/athletes_cubit.dart';
import 'package:sdeng/cubits/teams_cubit.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/utils/constants.dart';

class AddAthletePage extends StatelessWidget {
  const AddAthletePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider<TeamsCubit>(
          create: (context) => TeamsCubit(
            repository: RepositoryProvider.of<Repository>(context),
          )..loadTeams(),
          child: const AddAthletePage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsCubit, TeamsState>(
      builder: (context, state) {
        if (state is TeamsLoading) {
          return preloader;
        } else if (state is TeamsLoaded) {
          return AddAthleteForm(
            teams: state.teams.values.toList(),
          );
        } else if (state is TeamsError) {
          return const Center(child: Text('Something went wrong'));
        } else if (state is TeamsEmpty) {
          return const Center(child: Text('Add a team before'));
        }
        throw UnimplementedError();
      },
    );
  }
}

/// Main view of Athletes.
@visibleForTesting
class AddAthleteForm extends StatefulWidget {
  /// Main view of Athletes.
  AddAthleteForm({
    Key? key,
    List<Team>? teams,
  })  : _teams = teams ?? [],
        super(key: key);

  final List<Team> _teams;

  @override
  AddAthleteFormState createState() => AddAthleteFormState();
}

class AddAthleteFormState extends State<AddAthleteForm>{

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final surnameController = TextEditingController();

  final taxCodeController = TextEditingController();

  Team? selectedTeam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer16,
              spacer16,
              Text(
                'NEW ATHLETE',
                style: GoogleFonts.bebasNeue(
                    fontSize: 75,
                    color: black2
                )
              ),
              spacer16,
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Team',
                  style: TextStyle(
                    color: Color(0xff686f75),
                    fontSize: 16,
                  ),
                ),
              ),
              DropdownMenu<Team?>(
                hintText: 'Select the team',
                width: 250,
                enableSearch: false,
                onSelected: (value) => setState(() {
                  selectedTeam = value;
                }),
                trailingIcon: SvgPicture.asset('assets/icons/chevron-right.svg'),
                selectedTrailingIcon: SvgPicture.asset('assets/icons/chevron-down.svg'),
                dropdownMenuEntries: widget._teams.map((team) =>
                    DropdownMenuEntry(value: team, label: team.name)
                ).toList(),
              ),
              spacer16,
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Name',
                  style: TextStyle(
                    color: Color(0xff686f75),
                    fontSize: 16,
                  ),
                ),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('Mario'),
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
                  'Surname',
                  style: TextStyle(
                    color: Color(0xff686f75),
                    fontSize: 16,
                  ),
                ),
              ),
              TextFormField(
                controller: surnameController,
                decoration: const InputDecoration(
                  label: Text('Rossi'),
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
                  'Tax Code',
                  style: TextStyle(
                    color: Color(0xff686f75),
                    fontSize: 16,
                  ),
                ),
              ),
              TextFormField(
                controller: taxCodeController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  if (val.length != 16) {
                    return 'Not Valid';
                  }
                  return null;
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SdengPrimaryButton(
                        text: 'Confirm',
                        onPressed: () async {
                          String fullName = '${nameController.text} ${surnameController.text}';
                          if(_formKey.currentState!.validate() && selectedTeam != null) {
                            await BlocProvider.of<AthletesCubit>(context)
                                .addAthlete(selectedTeam!.id, fullName, taxCodeController.text);
                            Navigator.of(context).pop();
                          }
                        }
                    ),
                  )
                ],
              ),
              spacer16,
              spacer16,
              spacer16
            ],
          ),
        )
      ),
    );
  }
}