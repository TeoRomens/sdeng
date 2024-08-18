import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:sdeng/edit_medical/cubit/edit_medical_cubit.dart';
import 'package:sdeng/edit_medical/view/edit_medical_form.dart';

/// A modal dialog for editing medical records.
///
/// This widget uses the [EditMedicalCubit] to manage the state of the medical record being edited
/// and displays the [EditMedicalForm] for user input.
class EditMedicalModal extends StatelessWidget {
  /// Creates an [EditMedicalModal] widget.
  ///
  /// The [medical] parameter is required and represents the medical record to be edited.
  const EditMedicalModal({
    super.key,
    required Medical medical,
  }) : _medical = medical;

  /// The medical record to be edited.
  final Medical _medical;

  /// Creates a route to navigate to the [EditMedicalModal] page.
  ///
  /// This method is used to create a [MaterialPageRoute] that displays the [EditMedicalModal].
  static Route<void> route(Medical medical) => MaterialPageRoute<void>(
      builder: (_) => EditMedicalModal(
        medical: medical,
      ));

  /// The route name for the [EditMedicalModal].
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
