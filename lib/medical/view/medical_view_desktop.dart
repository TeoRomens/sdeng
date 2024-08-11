import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/medical/medicals.dart';
import 'package:sdeng/medicals_list/view/medicals_list_view_desktop.dart';

class MedicalViewDesktop extends StatelessWidget {
  const MedicalViewDesktop({super.key});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xlg
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextBox(
                title: 'Medical Visits',
                content: 'Below you find all your medical visits you have registered. First of all there are the expired ones.',
              ),
              if (bloc.state.status == MedicalStatus.loading)
                const LoadingBox()
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Adjust columns based on screen width
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: 4, // We have 4 categories: Expired, Expiring, Good, Unknown
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return MedicalCard(
                          title: 'Expired',
                          num: bloc.state.expiredMedicals.length,
                          image: Container(
                            color: AppColors.red,
                            child: const Icon(
                              FeatherIcons.x,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                          action: SecondaryButton(
                            text: 'View',
                            onPressed: () => Navigator.of(context).push(MedicalsListViewDesktop.route(bloc.state.expiredMedicals)),
                          ),
                        );
                      case 1:
                        return MedicalCard(
                          title: 'Expiring',
                          num: bloc.state.expiringMedicals.length,
                          image: Container(
                            color: AppColors.orange,
                            child: const Icon(
                              FeatherIcons.clock,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                          action: SecondaryButton(
                            text: 'View',
                            onPressed: () => Navigator.of(context).push(MedicalsListViewDesktop.route(bloc.state.expiringMedicals)),
                          ),
                        );
                      case 2:
                        return MedicalCard(
                          title: 'Good',
                          num: bloc.state.goodMedicals.length,
                          image: Container(
                            color: AppColors.green,
                            child: const Icon(
                              FeatherIcons.check,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                          action: SecondaryButton(
                            text: 'View',
                            onPressed: () => Navigator.of(context).push(MedicalsListViewDesktop.route(bloc.state.goodMedicals)),
                          ),
                        );
                      case 3:
                        return MedicalCard(
                          title: 'Unknown',
                          num: bloc.state.unknownMedicals.length,
                          image: Container(
                            color: AppColors.grey,
                            child: const Icon(
                              FeatherIcons.helpCircle,
                              color: AppColors.white,
                              size: 40,
                            ),
                          ),
                          action: SecondaryButton(
                            text: 'View',
                            onPressed: () => Navigator.of(context).push(MedicalsListViewDesktop.route(bloc.state.unknownMedicals)),
                          ),
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
