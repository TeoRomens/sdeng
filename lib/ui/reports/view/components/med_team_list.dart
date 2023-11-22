import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/ui/med_expires/view/med_expires_screen.dart';
import 'package:sdeng/ui/reports/bloc/events_bloc.dart';

import '../../../med_expires/view/shimmer.dart';

class MedTeamList extends StatelessWidget{
  const MedTeamList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if(state.medExamStatus == MedExamStatus.loading){
            return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: const ShimmerLoader()
            );
          }
          else if (state.medExamStatus == MedExamStatus.failure){
            return const Text('Error');
          }
          else if(state.medExamStatus == MedExamStatus.loaded && state.teamsList.isEmpty) {
            return const Text('No team added yet');
          }
          else {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.teamsList.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: ListTile(
                          tileColor: calculateTileColor(state.medExamExpiredMap, state.medExamNearExpireMap, state.teamsList[index].docId),
                          leading: const Icon(Icons.groups, color: Colors.white,),
                          title: Text(state.teamsList[index].name,),
                          trailing: Text(
                            '${state.medExamExpiredMap[state.teamsList[index].docId]} expired',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MedExpires(team: state.teamsList[index]),
                              ),
                            );
                          },
                        )
                    );
                  })
              ),
            );
          }
        }
    );
  }

  Color calculateTileColor(Map<String, int> expiredMap, Map<String, int> nearExpiredMap, String teamId){
    if(expiredMap.containsKey(teamId) && nearExpiredMap.containsKey(teamId)){
      if(expiredMap[teamId]! > 0){
        return const Color(0xFFFF4040);
      }else if(nearExpiredMap[teamId]! > 0) {
        return const Color(0xFFFFAE6A);
      }
      else {
        return const Color(0xFF5EBE4F);
      }
    }
    else {
      return const Color(0xFF7A7A7A);
    }
  }

}