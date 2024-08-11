import 'package:app_ui/app_ui.dart' hide AthleteInfoCard;
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athlete/athlete.dart';

/// Main view of Medicals.
class MedicalsListViewDesktop extends StatelessWidget {
  /// Main view of Medicals.
  const MedicalsListViewDesktop({
    super.key,
    required this.medicals,
  });

  static Route<Athlete> route(List<Medical> medicals) {
    return MaterialPageRoute<Athlete>(
      builder: (_) => MedicalsListViewDesktop(medicals: medicals),
    );
  }

  final List<Medical> medicals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Medicals list'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (medicals.isEmpty)
                const Center(
                  heightFactor: 5,
                  child: Text('It seems empty here'),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: medicals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.9,
                  ),
                  itemBuilder: (context, index) {
                    final medical = medicals[index];
                    return AthleteCard(
                      title: medical.fullName,
                      content: const SizedBox.shrink(),
                      image: Assets.images.logo3.svg(height: 60),
                      action: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            AthletePage.route(athleteId: medical.athleteId),
                          );
                        },
                        child: SecondaryButton(
                          text: 'View',
                          onPressed: () => Navigator.of(context).push(AthletePage.route(athleteId: medical.athleteId)),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
