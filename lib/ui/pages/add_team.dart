import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/cubits/teams_cubit.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/utils/constants.dart';

class AddTeamPage extends StatelessWidget {
  const AddTeamPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => TeamsCubit(
              repository: RepositoryProvider.of(context)
          ),
          child: const AddTeamPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final nameController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/logos/SDENG_logo.svg', height: 25),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer16,
              spacer16,
              Text(
                  'NEW TEAM',
                  style: GoogleFonts.bebasNeue(
                      fontSize: 75,
                      color: black2
                  )
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
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SdengPrimaryButton(
                        text: 'Confirm',
                        onPressed: () async {
                          await BlocProvider.of<TeamsCubit>(context)
                              .addTeam(nameController.text);
                          Navigator.of(context).pop();
                        }
                    ),
                  )
                ],
              ),
              spacer16,
              spacer16,
              spacer16
            ],
          )
      ),
    );
  }
}