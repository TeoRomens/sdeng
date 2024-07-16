import 'package:app_ui/app_ui.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/medical/cubit/medical_cubit.dart';
import 'package:sdeng/medical/widgets/athlete_med_tile.dart';
import 'package:sdeng/medical/widgets/medical_tile.dart';
import 'package:sdeng/medicals_list/view/medicals_list_view.dart';

class MedicalView extends StatelessWidget {
  const MedicalView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalCubit, MedicalState>(
      listener: (context, state) {
        if (state.status == MedicalStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Error getting medical visits.')),
            );
        }
      },
      builder: (BuildContext context, MedicalState state) {
        return const MedicalsScreen();
      },
    );
  }
}

/// Main view of Medicals.
@visibleForTesting
class MedicalsScreen extends StatelessWidget {
  /// Main view of Medicals.
  const MedicalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MedicalCubit>();

    return Scaffold(
      appBar: AppBar(
        title: AppLogo.light(),
        centerTitle: true,
      ),
      body: RefreshIndicator.adaptive(
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
                content: 'Below you find all your medical visits you have registered. First of all there are the expired ones.',
              ),
              if (bloc.state.status == MedicalStatus.loading)
                const LoadingBox()
              else ...[
                ...List.generate(
                  bloc.state.expiredMedicals.length,
                      (index) => AthleteMedTile(medical: bloc.state.expiredMedicals[index]),
                ),
                ...List.generate(
                  bloc.state.expiringMedicals.length,
                      (index) => AthleteMedTile(medical: bloc.state.expiringMedicals[index]),
                ),
                const Divider(height: 8),
                MedicalTile(
                  title: 'Good',
                  num: bloc.state.goodMedicals.length,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.green.shade100,
                    child: Icon(FeatherIcons.check, color: AppColors.green.shade800),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MedicalsListView.route(bloc.state.goodMedicals));
                  },
                ),
                MedicalTile(
                  title: 'Unknown',
                  num: bloc.state.unknownMedicals.length,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.grey.shade200,
                    child: Icon(FeatherIcons.helpCircle, color: AppColors.grey.shade800),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MedicalsListView.route(bloc.state.unknownMedicals));
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
