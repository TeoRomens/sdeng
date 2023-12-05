import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sdeng/ui/athlete_details/bloc/athlete_bloc.dart';
import 'package:sdeng/util/ui_utils.dart';

enum DocType {
  med,
  tess,
  iscr,
  other
}

class DocumentDialog extends StatefulWidget{
  const DocumentDialog(this.context, {super.key});

  final BuildContext context;

  @override
  State<DocumentDialog> createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<DocumentDialog> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  DocType docType = DocType.med;
  File? file;
  String? name;
  DateTime? expiringDate;
  final fileNameController = TextEditingController();
  String error = '';

  _buildChoiceList() {
    List<Widget> choices = [];
    choices.add(
        ChoiceChip(
          label: const Text('Med Visit'),
          selected: docType == DocType.med,
          onSelected: (selected) {
            setState(() {
              docType = DocType.med;
            });
          },
        )
    );
    choices.add(
        ChoiceChip(
          label: const Text('Mod Iscr'),
          selected: docType == DocType.iscr,
          onSelected: (selected) {
            setState(() {
              docType = DocType.iscr;
            });
          },
        )
    );
    choices.add(
        ChoiceChip(
          label: const Text('Tess FIP'),
          selected: docType == DocType.tess,
          onSelected: (selected) {
            setState(() {
              docType = DocType.tess;
            });
          },
        )
    );
    choices.add(
        ChoiceChip(
          label: const Text('Other'),
          selected: docType == DocType.other,
          onSelected: (selected) {
            setState(() {
              docType = DocType.other;
            });
          },
        )
    );
    return choices;
  }

  _uploadDocument() async {
    try{
      assert(file != null);

      if(docType == DocType.med){
        log('Uploading med file...');
        key.currentState?.save();
        assert(expiringDate != null);
        await widget.context.read<AthleteBloc>().uploadMedEventHandler(file!, expiringDate!);
      }
      else if(docType == DocType.tess){
        await widget.context.read<AthleteBloc>().uploadTessFIPEventHandler(file!);
      }
      else if(docType == DocType.iscr){
        await widget.context.read<AthleteBloc>().uploadModIscrEventHandler(file!);
      }
      else {
        assert(fileNameController.value.text.isNotEmpty);
        await widget.context.read<AthleteBloc>().uploadGenericEventHandler(file!, name!);
      }
      Get.back();
    } catch (e) {
      UIUtils.showError('Check all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Document',
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            children: _buildChoiceList(),
          ),
          const Divider(indent: 30, endIndent: 30, color: Colors.grey, height: 10,),
          const SizedBox(height: 10,),
          TextButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'docx', 'txt'],
                );
                if (result != null) {
                  setState(() {
                    file = File(result.files.single.path!);
                  });
                } else {
                  // User canceled the picker
                }
              },
              child: Text(
                file?.path ?? 'Choose File',
                style: const TextStyle(
                    color: Colors.white
                ),
              )
          ),
          Builder(
            builder: (context) {
              if(docType == DocType.med) {
                return Form(
                  key: key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: InputDatePickerFormField(
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime(2050),
                      onDateSaved: (value) {
                        expiringDate = value;
                      },
                      fieldLabelText: 'Expiring Date',
                    ),
                  ),
                );
              }
              else if(docType == DocType.tess || docType == DocType.iscr){
                return const SizedBox.shrink();
              }
              else {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: fileNameController,
                    decoration: const InputDecoration(
                        labelText: 'File name',
                    ),
                  ),
                );
              }
            }
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () async {
              UIUtils.awaitLoading(_uploadDocument());
            },
            child: const Text(
              'Add',
              style: TextStyle(
                  color: Colors.white
              ),
            )
        )
      ],
    );
  }
}