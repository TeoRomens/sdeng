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
            ? Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                      color: Color(0xFFE4E7EC),
                      width: 0.5
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Medical Visit', style: TextStyle(
                          letterSpacing: -0.02,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),),
                        ElevatedButton(
                          onPressed: () async {
                            await showAppModal(
                              context: context,
                              content: EditMedicalModal(medical: bloc.state.medical!,)
                              ).then((_) => bloc.reloadAthlete());
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0.2,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: Color(0xFFD0D5DD),
                                      width: 0.6
                                  )
                              )
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF344054),
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Expire', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                color: Color(0xFF8793A2)
                            ),),
                            Text(bloc.state.medical!.expirationDate!.dMY, style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),),
                            const SizedBox(height: 10),
                            const Text('Type', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                color: Color(0xFF8793A2)
                            ),),
                            Text(bloc.state.medical!.type.name, style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),),
                            const SizedBox(height: 10),
                          ],
                        ),
                        const FlutterLogo(
                          size: 87,
                        )
                      ],
                    ),
                  ],
                ),
              ),
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
