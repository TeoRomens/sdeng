import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athlete/view/athlete_page.dart';

/// A widget that displays a list of medical records.
///
/// If the list is empty, it shows a message indicating that no records are available.
/// Each medical record is represented as a tile, and tapping on a tile navigates to the
/// [AthletePage] for the associated athlete.
class MedicalsListView extends StatelessWidget {
  /// Creates an instance of [MedicalsListView].
  ///
  /// The [medicals] parameter is required and represents the list of medical records
  /// to be displayed.
  const MedicalsListView({
    super.key,
    required this.medicals,
  });

  /// Creates a route to navigate to the [MedicalsListView].
  ///
  /// This method is used to create a [MaterialPageRoute] with the given [medicals].
  static Route<List<Medical>> route(List<Medical> medicals) {
    return MaterialPageRoute<List<Medical>>(
      builder: (_) => MedicalsListView(medicals: medicals),
    );
  }

  /// The list of medical records to be displayed.
  final List<Medical> medicals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicals List'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: medicals.length,
                itemBuilder: (context, index) {
                  return AthleteMedicalTile(
                    medical: medicals[index],
                    onTap: () => Navigator.of(context).push(
                      AthletePage.route(athleteId: medicals[index].athleteId),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0, indent: 70, endIndent: 20),
              ),
          ],
        ),
      ),
    );
  }
}
