import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athlete/view/athlete_page.dart';
import 'package:sdeng/medicals_list/medicals_list.dart';

class MedicalsListView extends StatelessWidget {
  const MedicalsListView({
    super.key,
    required this.medicals
  });

  static Route<Athlete> route(List<Medical> medicals) {
    return MaterialPageRoute<Athlete>(
      builder: (_) => MedicalsListView(medicals: medicals,),
    );
  }

  final List<Medical> medicals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicals list'),
      ),
      body: MedicalsView(medicals: medicals,)
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class MedicalsView extends StatefulWidget {
  /// Main view of Athletes.
  MedicalsView({
    super.key,
    List<Medical>? medicals,
  })  : _medicals = medicals ?? [];

  final List<Medical> _medicals;

  @override
  MedicalsViewState createState() => MedicalsViewState();
}

/// State of AthleteList widget. Made public for testing purposes.
@visibleForTesting
class MedicalsViewState extends State<MedicalsView> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget._medicals.isEmpty)
            const Center(
              heightFactor: 5,
              child: Text('It seems empty here'),
            )
          else ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget._medicals.length,
            itemBuilder: (context, index) {
              return MedicalTile(
                medical: widget._medicals[index],
                onTap: () => Navigator.of(context).push(
                    AthletePage.route(athleteId: widget._medicals[index].athleteId)),
              );
            },
            separatorBuilder: (BuildContext context, int index)
              => const Divider(height: 0, indent: 70, endIndent: 20,)
          ),
        ],
      ),
    );
  }
}