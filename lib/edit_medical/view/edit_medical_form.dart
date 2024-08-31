import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/edit_medical/cubit/edit_medical_cubit.dart';

/// A form for editing medical records.
///
/// This form allows users to update the expiration date and type of a medical record.
class EditMedicalForm extends StatelessWidget {
  /// Creates an [EditMedicalForm] widget.
  ///
  /// The [medical] parameter is required and represents the medical record being edited.
  const EditMedicalForm({
    super.key,
    required this.medical,
  });

  /// The medical record being edited.
  final Medical medical;

  @override
  Widget build(BuildContext context) {
    final state = context.read<EditMedicalCubit>().state;

    final expireController = TextEditingController(text: medical.expire?.dMY);
    MedType? medType;

    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xlg,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Text(
              'Edit Medical',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(endIndent: 0, indent: 0, height: 25),
          AppTextFormField(
            label: 'Expire date',
            controller: expireController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 365)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                expireController.text = pickedDate.dMY;
              }
            },
            validator: (value) => state.expire.validator(value ?? '')?.text,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Type',
            style: UITextStyle.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 44,
            child: DropdownMenu(
              expandedInsets: const EdgeInsets.all(0),
              initialSelection: medical.type,
              enableSearch: false,
              onSelected: (value) => medType = value,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: MedType.agonistic,
                  label: 'Agonistic',
                ),
                DropdownMenuEntry(
                  value: MedType.not_agonistic,
                  label: 'Not Agonistic',
                ),
                DropdownMenuEntry(
                  value: MedType.not_required,
                  label: 'Not Required',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await context
                    .read<EditMedicalCubit>()
                    .updateMedical(
                  expire: expireController.text.toDateTime,
                  medType: medType,
                )
                    .then((_) => Navigator.of(context).pop());
              }
            },
            child: state.status == FormzSubmissionStatus.inProgress
                ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.white,
                strokeCap: StrokeCap.round,
              ),
            )
                : const Text('Save'),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
