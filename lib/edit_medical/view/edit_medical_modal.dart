import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:sdeng/edit_medical/cubit/edit_medical_cubit.dart';
import 'package:sdeng/edit_medical/view/edit_medical_form.dart';

class EditMedicalModal extends StatelessWidget {
  const EditMedicalModal({
    super.key,
    required Medical medical,
  }) : _medical = medical;

  final Medical _medical;

  static Route<void> route(Medical medical) => MaterialPageRoute<void>(
      builder: (_) => EditMedicalModal(
            medical: medical,
          ));

  static const String name = '/editMedicalModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditMedicalCubit(
        medicalsRepository: context.read<MedicalsRepository>(),
        medical: _medical,
      ),
      child: EditMedicalForm(medical: _medical),
    );
  }
}
