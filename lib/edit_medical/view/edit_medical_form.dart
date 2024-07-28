import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/edit_medical/cubit/edit_medical_cubit.dart';

class EditMedicalForm extends StatelessWidget {
  const EditMedicalForm({
    super.key,
    required this.medical,
  });

  final Medical medical;

  @override
  Widget build(BuildContext context) {
    final state = context.read<EditMedicalCubit>().state;

    final expireController = TextEditingController(text: medical.expirationDate?.dMY);
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
          const _ModalTitle(),
          const Divider(endIndent: 0, indent: 0, height: 25),
          AppTextFormField(
            label: 'Expire date',
            controller: expireController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 365)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100)
              );
              if(pickedDate != null) {
                expireController.text = pickedDate.dMY;
              }
            },
            validator: (value) => state.expire.validator(value ?? '')?.text,
          ),
          const SizedBox(height: AppSpacing.sm,),
          Text('Type', style: UITextStyle.label,),
          const SizedBox(height: AppSpacing.sm,),
          SizedBox(
            height: 44,
            child: DropdownMenu(
                expandedInsets: const EdgeInsets.all(0),
                initialSelection: medical.type,
                enableSearch: false,
                onSelected: (value) => medType = value,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: MedType.agonistic, label: 'Agonistic'),
                  DropdownMenuEntry(value: MedType.not_agonistic, label: 'Not Agonistic'),
                  DropdownMenuEntry(value: MedType.not_required, label: 'Not required')
                ]
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
          PrimaryButton(
            onPressed: () async {
              formKey.currentState!.validate()
                ? await context.read<EditMedicalCubit>().updateMedical(
                    expire: expireController.text.toDateTime,
                    medType: medType
                  ).then((_) => Navigator.of(context).pop())
                : null;
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

class _ModalTitle extends StatelessWidget {
  const _ModalTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Text(
        'Edit Medical',
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
