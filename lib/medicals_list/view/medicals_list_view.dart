import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/athlete/view/athlete_page.dart';

class MedicalsListView extends StatelessWidget {
  const MedicalsListView({
    super.key,
    required this.medicals,
  });

  static Route<Athlete> route(List<Medical> medicals) {
    return MaterialPageRoute<Athlete>(
      builder: (_) => MedicalsListView(medicals: medicals),
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
