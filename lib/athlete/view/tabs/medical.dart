import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:sdeng/add_medical/view/add_medical_modal.dart';
import 'package:sdeng/edit_medical/view/edit_medical_modal.dart';


/// A widget that displays the medical information of an athlete.
/// If medical data exists, it allows editing;
/// otherwise, it provides an option to add new data.
class MedicalInfo extends StatelessWidget {
  const MedicalInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<AthleteCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.lg),
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: AppSpacing.sm,
          ),
          bloc.state.status == AthleteStatus.loading
            ? const LoadingBox()
            : bloc.state.medical != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Medical Visit',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SecondaryButton(
                        text: 'Edit',
                        onPressed: () async {
                          await showAppModal(
                              context: context,
                              content: EditMedicalModal(
                                medical: bloc.state.medical!,
                              )).whenComplete(() => bloc.reloadMedical());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  CustomContainer(
                    icon: FeatherIcons.calendar,
                    text: bloc.state.medical!.expire?.dMY ?? '',
                  ),
                  CustomContainer(
                    icon: FeatherIcons.tag,
                    text: bloc.state.medical?.type?.name ?? '',
                  ),
                  if (bloc.state.medical?.expire != null) 
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Text('${bloc.state.medical?.expire?.difference(DateTime.now()).inDays} days to expire',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.black),),
                    )
                ],
              )
            : EmptyState(
              actionText: 'New medical',
              onPressed: () => showAppModal(
                context: context,
                content: AddMedicalModal(athlete: bloc.state.athlete!))
              )
        ],
      ),
    );
  }
}
