import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/medical/medicals.dart';
import 'package:sdeng/medicals_list/view/medicals_list_view_desktop.dart';

/// A desktop-specific view for displaying and managing medical records.
class MedicalViewDesktop extends StatelessWidget {
  /// Creates an instance of [MedicalViewDesktop].
  const MedicalViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MedicalCubit>();

    return RefreshIndicator.adaptive(
      onRefresh: () async {
        // Refreshes the lists of medical records.
        await Future.wait([
          bloc.getExpiredMedicals(),
          bloc.getExpiringMedicals(),
          bloc.getGoodMedicals(),
          bloc.getUnknownMedicals(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextBox(
                title: 'Medical Visits',
                content:
                    'Below you find all your medical visits you have registered. First of all, there are the expired ones.',
              ),
              if (bloc.state.status == MedicalStatus.loading)
                const LoadingBox()
              else
                _buildMedicalGrid(bloc, context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a grid of medical cards categorized by their status.
  Widget _buildMedicalGrid(MedicalCubit bloc, BuildContext context) {
    return GridView.builder(
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
            return _buildMedicalCard(
              title: 'Expired',
              count: bloc.state.expiredMedicals.length,
              color: AppColors.red,
              icon: FeatherIcons.x,
              context: context,
              medicals: bloc.state.expiredMedicals,
            );
          case 1:
            return _buildMedicalCard(
              title: 'Expiring',
              count: bloc.state.expiringMedicals.length,
              color: AppColors.orange,
              icon: FeatherIcons.clock,
              context: context,
              medicals: bloc.state.expiringMedicals,
            );
          case 2:
            return _buildMedicalCard(
              title: 'Good',
              count: bloc.state.goodMedicals.length,
              color: AppColors.green,
              icon: FeatherIcons.check,
              context: context,
              medicals: bloc.state.goodMedicals,
            );
          case 3:
            return _buildMedicalCard(
              title: 'Unknown',
              count: bloc.state.unknownMedicals.length,
              color: AppColors.grey,
              icon: FeatherIcons.helpCircle,
              context: context,
              medicals: bloc.state.unknownMedicals,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  /// Builds an individual [MedicalCard] widget with the given parameters.
  Widget _buildMedicalCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required BuildContext context,
    required List<Medical> medicals,
  }) {
    return MedicalCard(
      title: title,
      num: count,
      image: Container(
        color: color,
        child: Icon(icon, color: AppColors.white, size: 40),
      ),
      action: SecondaryButton(
        text: 'View',
        onPressed: () {
          Navigator.of(context).push(
            MedicalsListViewDesktop.route(medicals),
          );
        },
      ),
    );
  }
}
