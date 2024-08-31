import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/medical/cubit/medical_cubit.dart';
import 'package:sdeng/medicals_list/view/medicals_list_view.dart';

/// A view that displays and manages medical records.
///
/// It shows a list of medical records categorized by their status:
/// expired, expiring, good, and unknown. The view supports pull-to-refresh
/// functionality to update the medical records.
class MedicalView extends StatelessWidget {
  /// Creates an instance of [MedicalView].
  const MedicalView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MedicalCubit>();

    return RefreshIndicator.adaptive(
      onRefresh: () async => await bloc.fetchMedicals(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
              else ...[
                _buildMedicalTile(
                  title: 'Expired',
                  count: bloc.state.expiredMedicals.length,
                  color: AppColors.red,
                  icon: FeatherIcons.x,
                  context: context,
                  medicals: bloc.state.expiredMedicals,
                ),
                _buildMedicalTile(
                  title: 'Expiring',
                  count: bloc.state.expiringMedicals.length,
                  color: AppColors.orange,
                  icon: FeatherIcons.clock,
                  context: context,
                  medicals: bloc.state.expiringMedicals,
                ),
                _buildMedicalTile(
                  title: 'Good',
                  count: bloc.state.goodMedicals.length,
                  color: AppColors.green,
                  icon: FeatherIcons.check,
                  context: context,
                  medicals: bloc.state.goodMedicals,
                ),
                _buildMedicalTile(
                  title: 'Unknown',
                  count: bloc.state.unknownMedicals.length,
                  color: AppColors.grey,
                  icon: FeatherIcons.helpCircle,
                  context: context,
                  medicals: bloc.state.unknownMedicals,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a [MedicalTile] for the given medical category.
  ///
  /// This helper method creates a [MedicalTile] with the provided
  /// [title], [count], [color], [icon], and [medicals]. It also handles
  /// the navigation to a detailed view of the medical records when the
  /// tile is tapped.
  Widget _buildMedicalTile({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
    required BuildContext context,
    required List<Medical> medicals,
  }) {
    return MedicalTile(
      title: title,
      num: count,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color,
        child: Icon(icon, color: AppColors.white),
      ),
      onTap: () {
        Navigator.of(context).push(MedicalsListView.route(medicals));
      },
    );
  }
}
