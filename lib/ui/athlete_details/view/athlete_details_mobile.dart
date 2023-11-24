import 'package:flutter/gestures.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/common/payment_card.dart';
import 'package:sdeng/common/payment_tile.dart';
import 'package:sdeng/common/text_title.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/ui/athlete_details/bloc/athlete_bloc.dart';
import 'package:sdeng/ui/athlete_details/components/document_dialog.dart';
import 'package:sdeng/ui/athlete_details/components/payment_dialog.dart';
import 'package:sdeng/ui/athlete_details/view/shimmer.dart';
import 'package:sdeng/ui/edit_athlete/view/edit_athlete_screen.dart';

class AthleteDetailsMobile extends StatelessWidget {
  const AthleteDetailsMobile(this.athlete, {super.key});

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AthleteBloc, AthleteState>(
        listener: (context, state) {
          if (state.uploadStatus == UploadStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Lottie.asset('assets/animations/successful.json')
                  )
              ),
            );
          }
        },
        builder: (context, state) {
          if(state.pageStatus == PageStatus.loading) {
            return const ShimmerLoader();
          }
          else {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AthleteBloc>()..loadAthlete(athlete.docId)..loadAthleteDetails(athlete.parentId);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            decoration: const BoxDecoration(
                                color: Color(0xffE7E6FF),
                                shape: BoxShape.circle
                            ),
                            width: 80,
                            height: 80,
                            child: Center(
                              child: Text(
                                state.athlete.number.toString(),
                                style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff4D46B2)
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${state.athlete.name} ${state.athlete.surname}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      LabelledText(text: '${state.athlete.birth.toDate().day}/${state.athlete.birth.toDate().month}/${state.athlete.birth.toDate().year}', label: 'Data di Nascita'),
                      LabelledText(text: state.athlete.taxId, label: 'Tax ID'),
                      LabelledText(text: '${state.athlete.address}, ${state.athlete.city}', label: 'Address'),
                      LabelledText(text: state.athlete.email, label: 'Email'),
                      LabelledText(text: state.athlete.phone, label: 'Phone'),
                      const Divider(indent: 30,
                        endIndent: 30,
                        color: Colors.grey,
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Parent',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      LabelledText(text: '${state.parent!.name} ${state.parent!.surname}', label: 'Name and Surname'),
                      LabelledText(text: state.parent!.email, label: 'Email'),
                      LabelledText(text: state.parent!.phone, label: 'Phone'),
                      LabelledText(text: state.parent!.taxId, label: 'Tax ID'),
                      const Divider(
                        indent: 30,
                        endIndent: 30,
                        color: Colors.grey,
                        height: 40,
                      ),
                      const TextTitle('Payments'),
                      PaymentCard(quota: state.athlete.amount),
                      const SizedBox(height: 12),
                      state.payments.isEmpty
                        ? Align(
                          alignment: Alignment.center,
                          child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.grey.shade200,
                              elevation: 0,
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No payments',),
                              )
                          ),
                        )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.payments.length,
                            itemBuilder: (context, index) {
                              return PaymentTile(
                                  payment: state.payments[index],
                                  onTap: (dialogContext) {

                                  }
                              );
                            }
                        ),
                      const Divider(indent: 30,
                        endIndent: 30,
                        color: Colors.grey,
                      ),
                      const TextTitle('Documents'),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          state.medLink.isEmpty && state.modIscrLink.isEmpty && state.tessFIPLink.isEmpty
                            ? Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              color: Colors.grey.shade200,
                              elevation: 0,
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No documents added',),
                              )
                            )
                            : const SizedBox.shrink(),

                          state.medLink.isNotEmpty
                            ? const ListTile(
                              tileColor: Color(0xffE7E6FF),
                              title: Text('Med Visit'),
                            )
                            : const SizedBox.shrink(),

                          state.modIscrLink.isNotEmpty
                            ? const ListTile()
                            : const SizedBox.shrink(),

                          state.tessFIPLink.isNotEmpty
                            ? const ListTile()
                            : const SizedBox.shrink(),

                          state.otherFilesMap.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.otherFilesMap.length,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Slidable(
                                        key: Key(state.otherFilesMap.keys.elementAt(index)),
                                        dragStartBehavior: DragStartBehavior.start,
                                        startActionPane: ActionPane(
                                          motion: const BehindMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (BuildContext dialogContext) async {
                                                final bloc = context.read<AthleteBloc>();
                                                final result = await showDialog<bool>(
                                                    context: dialogContext,
                                                    builder: (BuildContext dialogContext) =>
                                                        AlertDialog(
                                                          title: const Text('Are you sure to remove this document?'),
                                                          content: const Text('This action can\'t be undo!'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () => Navigator.pop(dialogContext, false),
                                                                child: const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors.white
                                                                  ),
                                                                )
                                                            ),
                                                            TextButton(
                                                                onPressed: () => Navigator.pop(dialogContext, true),
                                                                child: const Text(
                                                                  'OK',
                                                                  style: TextStyle(
                                                                      color: Colors.white
                                                                  ),
                                                                )
                                                            )
                                                          ],
                                                        )
                                                );
                                                if (result == true) {
                                                  bloc.deleteDocumentEventHandler('altri/${state.athlete.teamId}/${state.athlete.docId}/${state.otherFilesMap.keys.elementAt(index)}');
                                                }
                                              },
                                              backgroundColor: const Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          tileColor: const Color(0xffd5eaff),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12)
                                          ),
                                          leading: Image.asset('assets/icons/file.png', height: 35,),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Color(0xff004aad),
                                          ),
                                          title: Text(
                                            state.otherFilesMap.keys.elementAt(index),
                                            style: const TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onTap: () {

                                          }
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )
                              : const SizedBox.shrink(),
                          const Divider(indent: 30,
                            endIndent: 30,
                            color: Colors.grey,
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (dialogContext) => PaymentDialog(context)
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff4D46B2),
                                    foregroundColor: const Color(0xffE7E6FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                            width: 0.4
                                        )
                                    )
                                ),
                                child: const Text('Add Payment')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (dialogContext) => DocumentDialog(context)
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff4D46B2),
                                    foregroundColor: const Color(0xffE7E6FF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: const BorderSide(
                                            width: 0.4
                                        )
                                    )
                                ),
                                child: const Text('Add Document')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditAthleteScreen(athlete: state.athlete, parent: state.parent!),
                                  ),
                                );
                              },
                              child: const Text('Edit Athlete')
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                )
              ),
            );
          }
        }
      );
  }
}

class BoxClipRRect extends StatelessWidget {
  const BoxClipRRect({
    super.key,
    required this.text,
    required this.iconPath,
    required this.color
  });

  final String text;
  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                  height: 55,
                  child: Image.asset(iconPath)
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 12, 12),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LabelledText extends StatelessWidget {
  const LabelledText({
    super.key,
    required this.text,
    required this.label
  });

  final String text;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.grey
            ),
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.black,
              fontSize: 18
            ),
          ),
        ],
      ),
    );
  }
}