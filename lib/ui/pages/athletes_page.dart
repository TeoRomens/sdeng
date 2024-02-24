import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sdeng/cubits/athletes_cubit.dart';
import 'package:sdeng/cubits/teams_cubit.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/ui/pages/add_athlete.dart';
import 'package:sdeng/utils/constants.dart';

class AthletesPage extends StatefulWidget {
  const AthletesPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return const AthletesPage();
      },
    );
  }

  @override
  State<AthletesPage> createState() => _AthletesPageState();
}

class _AthletesPageState extends State<AthletesPage> {

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
                  text: 'New Athlete',
                  onPressed: () => Navigator.of(context).push(AddAthletePage.route())
              ),
              spacer16,
              SizedBox(
                height: 48,
                child: SearchBar(
                  hintText: 'Search',
                  trailing: [
                    IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.search)
                    ),
                  ]
                ),
              ),
              spacer16,
              const Text('Athletes', style: TextStyle(
                  fontSize: 26
              ),),
              spacer16,
              BlocConsumer<AthletesCubit, AthletesState>(
                listener: (context, state) {
                  if (state is AthletesError) {
                    context.showErrorSnackBar(message: state.error);
                  }
                },
                builder: (context, state) {
                  if (state is AthletesInitial) {
                    return preloader;
                  }
                  else if (state is AthletesLoaded) {
                    final athletes = state.athletes;
                    return Column(
                      children: [
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: athletes.length,
                          itemBuilder: (context, index) {
                            final athlete = athletes.values.elementAt(index);
                            return ListTile(
                              title: Text(athlete!.fullName),
                              leading: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: const BorderRadius.all(Radius.circular(4))
                                  ),
                                  width: 35,
                                  height: 35,
                                  child: Icon(Icons.person_outlined, color: Colors.grey.shade700,)
                              ),
                              trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
                              contentPadding: const EdgeInsets.only(left: 5, right: 5),
                              onTap: () {

                              },
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
                            child: Text('Start adding your first athlete!'),
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