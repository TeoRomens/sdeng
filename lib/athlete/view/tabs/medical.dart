import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/athlete/view/add_medical_modal.dart';
import 'package:sdeng/edit_medical/view/edit_medical_modal.dart';

class MedicalInfo extends StatelessWidget {
  const MedicalInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: AppSpacing.sm,),
          bloc.state.status == AthleteStatus.loading
            ? const LoadingBox()
            : bloc.state.medical != null
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Medical Visit',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SecondaryButton(
                      onPressed: () async {
                        await showAppModal(
                            context: context,
                            content: EditMedicalModal(medical: bloc.state.medical!,)
                        ).then((_) => bloc.reloadAthlete());
                      },
                      text: 'Edit',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm,),
                CustomContainer(
                  icon: FeatherIcons.calendar,
                  text: bloc.state.medical!.expirationDate?.dMY ?? '',
                ),
                CustomContainer(
                  icon: FeatherIcons.tag,
                  text: bloc.state.medical!.type.name,
                ),
              ],
            )
            : EmptyState(
                actionText: 'New medical',
                onPressed: () =>
                  showAppModal(
                      context: context,
                      content: AddMedicalModal(athlete: bloc.state.athlete!)
                )
              )
        ],
      ),
    );
  }
}
