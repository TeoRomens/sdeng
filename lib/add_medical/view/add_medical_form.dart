import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/add_medical/cubit/add_medical_cubit.dart';

class AddMedicalForm extends StatefulWidget {
  const AddMedicalForm({super.key});

  @override
  State<AddMedicalForm> createState() => _AddMedicalFormState();
}

class _AddMedicalFormState extends State<AddMedicalForm> {
  MedType? currentOption = MedType.agonistic;
  final _expireController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddMedicalCubit>().state;

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
              'New medical visit',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            endIndent: 0,
            indent: 0,
            height: 25,
          ),
          RadioListTile.adaptive(
            value: MedType.agonistic,
            groupValue: currentOption,
            onChanged: (value) {
              setState(() {
                currentOption = value;
              });
            },
            title: Text(
              'Agonistic',
              style: UITextStyle.bodyLarge,
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
            useCupertinoCheckmarkStyle: true,
          ),
          RadioListTile.adaptive(
            value: MedType.not_agonistic,
            groupValue: currentOption,
            onChanged: (value) {
              setState(() {
                currentOption = value;
              });
            },
            title: Text('Not agonistic', style: UITextStyle.bodyLarge),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
            useCupertinoCheckmarkStyle: true,
          ),
          RadioListTile.adaptive(
            value: MedType.not_required,
            groupValue: currentOption,
            onChanged: (value) {
              setState(() {
                currentOption = value;
              });
            },
            title: Text('Not required', style: UITextStyle.bodyLarge),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
            useCupertinoCheckmarkStyle: true,
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          AppTextFormField(
            label: 'Expire',
            controller: _expireController,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100));
              if (selectedDate != null) {
                _expireController.text = selectedDate.dMY;
              }
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (currentOption != MedType.not_required &&
                  (value == null || value.isEmpty)) {
                return 'Required';
              }
              return null;
            },
          ),
          const SizedBox(
            height: AppSpacing.xlg,
          ),
          PrimaryButton(
            onPressed: () async {
              _formKey.currentState!.validate()
                  ? await context
                      .read<AddMedicalCubit>()
                      .addMedical(
                        type: currentOption ?? MedType.agonistic,
                        expire: _expireController.text.toDateTime!,
                      )
                      .then((_) => Navigator.of(context).pop())
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
                : Text('Add', style: Theme.of(context).textTheme.labelLarge,),
          ),
          const SizedBox(
            height: AppSpacing.xlg,
          ),
        ],
      ),
    );
  }
}
