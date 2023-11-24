import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/common/player_tile.dart';
import 'package:sdeng/ui/payments/bloc/payments_bloc.dart';

class PaymentsMobile extends StatefulWidget {
  const PaymentsMobile({Key? key}) : super(key: key);

  @override
  State<PaymentsMobile> createState() => _PaymentsMobileState();
}

class _PaymentsMobileState extends State<PaymentsMobile> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
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
                        label: const Text('Not pay'),
                        selectedColor: Colors.red.shade500,
                        selected: index == 0,
                        onSelected: (selected) {
                          setState(() {
                            index = 0;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Partial'),
                        selectedColor: Colors.yellow.shade700,
                        selected: index == 1,
                        onSelected: (selected) {
                          setState(() {
                            index = 1;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Good'),
                        selected: index == 2,
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
                            const Text(
                              'Athletes do not paid',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const Text(
                              'Below a list of athletes who didn\'t pay',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),
                            ),
                            const SizedBox(height: 10,),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.notPayList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: PlayerTileWidget(athlete: state.notPayList[index],),
                                  );
                                }
                            )
                          ],
                        );
                      }
                      else if(index == 1) {
                        return Column(
                          children: [
                            const Text(
                              'Athletes paid partial',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const Text(
                              'Below a list of athletes who paid only partial',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),
                            ),
                            const SizedBox(height: 10,),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.partialList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: PlayerTileWidget(athlete: state.partialList[index],),
                                );
                              }
                            )
                          ],
                        );
                      }
                      else if(index == 2) {
                        return Column(
                          children: [
                            const Text(
                              'Athlete ok',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            const Text(
                              'Below a list of athletes ok with payments',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),
                            ),
                            const SizedBox(height: 10,),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.okList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: PlayerTileWidget(athlete: state.okList[index],),
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