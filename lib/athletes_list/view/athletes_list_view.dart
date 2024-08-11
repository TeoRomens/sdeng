import 'package:app_ui/app_ui.dart';
import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthletesListView extends StatefulWidget {
  const AthletesListView({
    super.key,
  });

  static Route<Athlete> route() {
    return MaterialPageRoute<Athlete>(
      builder: (_) => const AthletesListView(),
    );
  }

  @override
  State<AthletesListView> createState() => _AthletesListViewState();
}

class _AthletesListViewState extends State<AthletesListView> {
  List<Athlete> _athletes = [];
  bool _loading = true;

  @override
  void initState() {
    fetchAthletes();
    super.initState();
  }

  Future<void> fetchAthletes() async {
    _athletes = await context.read<AthletesRepository>().getAthleteList();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select athlete'),
      ),
      body: _loading
        ? const LoadingBox()
        : AthletesPopulated(athletes: _athletes,)
    );
  }
}

/// Main view of Teams.
@visibleForTesting
class AthletesPopulated extends StatefulWidget {
  /// Main view of Athletes.
  AthletesPopulated({
    super.key,
    List<Athlete>? athletes,
  })  : _athletes = athletes ?? [];

  final List<Athlete> _athletes;

  @override
  AthletesPopulatedState createState() => AthletesPopulatedState();
}

/// State of AthleteList widget. Made public for testing purposes.
@visibleForTesting
class AthletesPopulatedState extends State<AthletesPopulated> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget._athletes.isEmpty)
            const Center(
              heightFactor: 5,
              child: Text('It seems empty here'),
            )
          else ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget._athletes.length,
            itemBuilder: (context, index) {
              return AthleteTile(
                athlete: widget._athletes[index],
                onTap: () => Navigator.of(context).pop(widget._athletes[index]),
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