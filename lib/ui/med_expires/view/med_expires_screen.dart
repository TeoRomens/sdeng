import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/ui/med_expires/view/shimmer.dart';
import 'package:sdeng/ui/med_expires/bloc/med_expires_bloc.dart';

class MedExpires extends StatelessWidget {
  const MedExpires({
    super.key,
    required this.team,
  });

  final Team team;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MedExpiresBloc()..load(team),
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Med Exams ${team.name}',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
        ),
        body: BlocBuilder<MedExpiresBloc, MedExpiresState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return const ShimmerLoader();
            }
            else if (state.status == Status.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Load Failed'),
                    const SizedBox(height: 8.0,),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MedExpiresBloc>().load(team);
                      },
                      child: const Text('Reload'),
                    )
                  ],
                ),
              );
            }
            else {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MedExpiresBloc>().load(team);
                },
                child: SafeArea(
                  minimum: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()
                        ),
                        itemCount: state.expiresDateList.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
                            child: ListTile(
                                tileColor: calculateTileColor(state.expiresDateList[index]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                leading: Text(
                                  '${state.athletesList[index].number}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: DateTime.now().isAfter(state.expiresDateList[index])
                                    ? SizedBox(
                                      height: 40,
                                      width: 100,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                          ),
                                          onPressed: () async {
                                            var pickedFile = await FilePicker.platform.pickFiles();
                                            if(pickedFile != null){
                                              DateTime? selectedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                                lastDate: DateTime.now().add(const Duration(days: 600)),
                                                helpText: 'Select expiring date',
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
                                              if(selectedDate != null){
                                                context.read<MedExpiresBloc>().uploadMedEventHandler(platformFile: pickedFile.files.first, expire: selectedDate, athleteId: state.athletesList[index].docId, teamId: state.team!.docId,);
                                                //overlayState.insert(loadingOverlay);
                                              }
                                            }
                                          },
                                          child: const Text('Update'),
                                      ),
                                    )
                                    : null,
                                title: Text(
                                  '${state.athletesList[index].name} ${state.athletesList[index].surname}',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                  ),
                                ),
                              subtitle: Text(
                                'Expire: ${state.expiresDateList[index].day}/${state.expiresDateList[index].month}/${state.expiresDateList[index].year}',
                                style: const TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          );
                        })
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ListTile(
                          tileColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          leading: const Icon(Icons.question_mark),
                          title: Text(
                            '${state.athletesList.length - state.expiresDateList.length} unknown',
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      )
    );
  }

  Color calculateTileColor(DateTime expireDate){
    if(DateTime.now().isAfter(expireDate)){
      return const Color(0xFFFF4040);
    }else if(DateTime.now().add(const Duration(days: 30)).isAfter(expireDate)) {
      return const Color(0xFFFFAE6A);
    }
    else {
      return const Color(0xFF5EBE4F);
    }
  }
}
