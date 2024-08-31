import 'package:app_ui/app_ui.dart' hide AthleteInfoCard;
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athlete/athlete.dart';

/// A desktop-specific view for displaying a list of medical records in a grid layout.
///
/// This view displays a grid of medical records, where each item represents a medical record
/// and allows navigation to a detailed view of the associated athlete.
///
/// It is designed to be used on larger screens such as desktops or tablets, adapting the layout
/// to fit more content in a grid format.
class MedicalsListViewDesktop extends StatelessWidget {
  /// Creates an instance of [MedicalsListViewDesktop].
  ///
  /// [medicals] is a list of medical records to be displayed in the grid.
  const MedicalsListViewDesktop({
    super.key,
    required this.medicals,
  });

  /// Creates a [MaterialPageRoute] to navigate to the [MedicalsListViewDesktop].
  ///
  /// [medicals] is a list of medical records to be displayed.
  static Route<Athlete> route(List<Medical> medicals) {
    return MaterialPageRoute<Athlete>(
      builder: (_) => MedicalsListViewDesktop(medicals: medicals),
    );
  }

  /// A list of medical records to be displayed.
  final List<Medical> medicals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicals List'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (medicals.isEmpty)
                EmptyState(
                  showAction: false,
                  actionText: '',
                  onPressed: () {}
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: medicals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Number of columns in the grid
                    mainAxisSpacing: 10, // Vertical space between items
                    crossAxisSpacing: 10, // Horizontal space between items
                    childAspectRatio: 1.9, // Aspect ratio of each item
                  ),
                  itemBuilder: (context, index) {
                    final medical = medicals[index];
                    return AthleteCard(
                      title: medical.fullName, // Display the athlete's full name
                      content: const SizedBox.shrink(), // Placeholder for additional content
                      image: Assets.images.logo3.svg(height: 60), // Placeholder image
                      action: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            AthletePage.route(athleteId: medical.athleteId),
                          );
                        },
                        child: SecondaryButton(
                          text: 'View', // Text for the button
                          onPressed: () => Navigator.of(context).push(
                            AthletePage.route(athleteId: medical.athleteId),
                          ),
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
