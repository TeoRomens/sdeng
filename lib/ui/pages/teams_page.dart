import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/cubits/teams_cubit.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/utils/constants.dart';

class TeamsPage extends StatelessWidget {
  TeamsPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        BlocProvider.of<TeamsCubit>(context).loadTeams();
        return TeamsPage();
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  void _newTeamModal(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => ConstrainedBox(
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
                  const Text('New Team', style: TextStyle(
                      inherit: false,
                      fontSize: 26,
                      color: Colors.black
                  ),),
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
                      label: Text('U15'),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  spacer16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SdengDefaultButton(
                          text: 'Cancel',
                          onPressed: () {
                            nameController.dispose();
                            Navigator.of(context).pop();
                          }
                      ),
                      const SizedBox(width: 10,),
                      SdengPrimaryButton(
                          text: 'Confirm',
                          onPressed: () async {
                            if(_formKey.currentState!.validate()) {
                              await BlocProvider.of<TeamsCubit>(context)
                                .addTeam(nameController.text);
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
        )
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
                  text: 'New Team',
                  onPressed: () => _newTeamModal(context)
              ),
              spacer16,
              const Text('Teams', style: TextStyle(
                  fontSize: 26
              ),),
              spacer16,
              BlocConsumer<TeamsCubit, TeamsState>(
                listener: (context, state) {
                  if (state is TeamsError) {
                    context.showErrorSnackBar(message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is TeamsInitial) {
                    return preloader;
                  }
                  else if (state is TeamsLoaded) {
                    final teams = state.teams;
                    return Column(
                      children: [
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: teams.length,
                          itemBuilder: (context, index) {
                            final team = teams.values.elementAt(index);
                            return ListTile(
                              title: Text(team!.name),
                              leading: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.all(Radius.circular(4))
                                  ),
                                  width: 35,
                                  height: 35,
                                  child: Icon(Icons.groups_outlined, color: Colors.grey.shade700,)
                              ),
                              trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
                              contentPadding: const EdgeInsets.only(left: 5, right: 5),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 20,
                            );
                          },
                        ),
                      ],
                    );
                  } else if (state is TeamsEmpty) {
                    return const Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text('Start adding your first team!'),
                          ),
                        ),
                      ],
                    );
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