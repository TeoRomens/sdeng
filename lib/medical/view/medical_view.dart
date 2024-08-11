import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/medical/cubit/medical_cubit.dart';
import 'package:sdeng/medicals_list/view/medicals_list_view.dart';

/// Main view of Medicals.
class MedicalView extends StatelessWidget {
  /// Main view of Medicals.
  const MedicalView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MedicalCubit>();

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        bloc.getExpiredMedicals();
        bloc.getUnknownMedicals();
        bloc.getGoodMedicals();
        bloc.getUnknownMedicals();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextBox(
              title: 'Medical Visits',
              content:
                  'Below you find all your medical visits you have registered. First of all there are the expired ones.',
            ),
            if (bloc.state.status == MedicalStatus.loading)
              const LoadingBox()
            else ...[
              MedicalTile(
                title: 'Expired',
                num: bloc.state.expiredMedicals.length,
                leading: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.red,
                  child: Icon(FeatherIcons.x, color: AppColors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MedicalsListView.route(bloc.state.expiredMedicals));
                },
              ),
              MedicalTile(
                title: 'Expiring',
                num: bloc.state.expiringMedicals.length,
                leading: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.orange,
                  child: Icon(FeatherIcons.clock, color: AppColors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MedicalsListView.route(bloc.state.expiringMedicals));
                },
              ),
              MedicalTile(
                title: 'Good',
                num: bloc.state.goodMedicals.length,
                leading: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.green,
                  child: Icon(FeatherIcons.check, color: AppColors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MedicalsListView.route(bloc.state.goodMedicals));
                },
              ),
              MedicalTile(
                title: 'Unknown',
                num: bloc.state.unknownMedicals.length,
                leading: const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.grey,
                  child: Icon(FeatherIcons.helpCircle, color: AppColors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MedicalsListView.route(bloc.state.unknownMedicals));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
