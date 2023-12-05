import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/common/player_tile.dart';
import 'package:sdeng/ui/athlete_details/view/responsive.dart';
import 'package:sdeng/ui/med_visits/bloc/med_bloc.dart';

class MedVisitsMobile extends StatefulWidget {
  const MedVisitsMobile({Key? key}) : super(key: key);

  @override
  State<MedVisitsMobile> createState() => _MedVisitsMobileState();
}

class _MedVisitsMobileState extends State<MedVisitsMobile> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedBloc, MedState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
              children: [
                const SizedBox(height: 20,),
                Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 15,
                    children: [
                      ChoiceChip(
                        label: const Text('Expired'),
                        selectedColor: Colors.red.shade500,
                        selected: index == 0,
                        onSelected: (selected) {
                          setState(() {
                            index = 0;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Near'),
                        selectedColor: Colors.yellow.shade700,
                        selected: index == 1,
                        onSelected: (selected) {
                          setState(() {
                            index = 1;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Unknown'),
                        selected: index == 2,
                        selectedColor: Colors.blue.shade500,
                        onSelected: (selected) {
                          setState(() {
                            index = 2;
                          });
                        },
                      )
                    ]
                ),
                const SizedBox(height: 15,),
                Builder(
                    builder: (context) {
                      if(index == 0) {
                        return Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Athletes with expired med visit',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Below a list of athletes with already expired medical visit',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            state.expiredList.isEmpty ?
                            Card(
                                margin: const EdgeInsets.symmetric(vertical: 30),
                                color: Colors.grey.shade200,
                                elevation: 0,
                                child: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text('No results',),
                                )
                            ) :
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.expiredList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: PlayerTileWidget(
                                      athlete: state.expiredList[index],
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => AthleteDetails(state.expiredList[index])
                                          )
                                      ),
                                    ),
                                  );
                                }
                            )
                          ],
                        );
                      }
                      else if(index == 1) {
                        return Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Athletes with near expiring visit',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Below a list of athletes with expiring in less than 15 days',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            state.nearExpiredList.isEmpty ?
                            Card(
                                margin: const EdgeInsets.symmetric(vertical: 30),
                                color: Colors.grey.shade200,
                                elevation: 0,
                                child: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text('No results',),
                                )
                            ) :
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.nearExpiredList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: PlayerTileWidget(
                                    athlete: state.nearExpiredList[index],
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => AthleteDetails(state.nearExpiredList[index])
                                        )
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        );
                      }
                      else if(index == 2) {
                        return Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Athlete unknown',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Below a list of athletes with no info about their med visit',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            state.unknownList.isEmpty ?
                            Card(
                                margin: const EdgeInsets.symmetric(vertical: 30),
                                color: Colors.grey.shade200,
                                elevation: 0,
                                child: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text('No results',),
                                )
                            ) :
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.unknownList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: PlayerTileWidget(
                                      athlete: state.unknownList[index],
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => AthleteDetails(state.unknownList[index])
                                          )
                                      ),
                                    ),
                                  );
                                }
                            )
                          ],
                        );
                      }
                      else {
                        return const Text(
                          'Select a option to visualize',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
                          ),
                        );
                      }
                    }
                ),
              ]
          ),
        );
      },
    );
  }
}