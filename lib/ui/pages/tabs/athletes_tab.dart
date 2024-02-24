import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdeng/cubits/athletes_cubit.dart';
import 'package:sdeng/cubits/teams_cubit.dart';
import 'package:sdeng/model/athlete.dart';
import 'package:sdeng/model/team.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/components/RoundedBox2Values.dart';
import 'package:sdeng/ui/components/button.dart';
import 'package:sdeng/ui/pages/add_athlete.dart';
import 'package:sdeng/ui/pages/add_team.dart';
import 'package:sdeng/utils/constants.dart';

class AthletesTab extends StatelessWidget {
  const AthletesTab({Key? key}) : super(key: key);

  /// Method ot create this page with necessary `BlocProvider`
  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TeamsCubit>(
          create: (context) => TeamsCubit(
            repository: RepositoryProvider.of<Repository>(context),
          )..loadTeams(),
        ),
        BlocProvider<AthletesCubit>(
          create: (context) => AthletesCubit(
            repository: RepositoryProvider.of<Repository>(context),
          )..loadInitialAthletes(),
        ),
      ],
      child: const AthletesTab(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamsCubit, TeamsState>(
      builder: (context, teamState) =>
          BlocBuilder<AthletesCubit, AthletesState>(
            builder: (context, athleteState) {
              if (athleteState is AthletesLoading || teamState is TeamsLoading) {
                return preloader;
              } else if (athleteState is AthletesLoaded && teamState is TeamsLoaded) {
                return AthletesList(
                  athletes: athleteState.athletes.values.toList(),
                  teams: teamState.teams.values.toList(),
                );
              } else if (athleteState is AthletesError || teamState is TeamsError) {
                return const Center(child: Text('Something went wrong'));
              } else if (teamState is TeamsEmpty) {
                return const Center(child: Text('Teams is empty'));
              }
              throw UnimplementedError();
            },
          ),
    );
  }
}

/// Main view of Athletes.
@visibleForTesting
class AthletesList extends StatefulWidget {
  /// Main view of Athletes.
  AthletesList({
    Key? key,
    List<Athlete>? athletes,
    List<Team>? teams,
  })  : _athletes = athletes ?? [],
        _teams = teams ?? [],
        super(key: key);

  final List<Athlete> _athletes;
  final List<Team> _teams;

  @override
  AthletesListState createState() => AthletesListState();
}

/// State of AthleteList widget. Made public for testing purposes.
@visibleForTesting
class AthletesListState extends State<AthletesList> {

  final TextEditingController _searchController =
    TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        spacer16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedBox2Values(
                text: 'Teams',
                value: widget._teams.length
            ),
            RoundedBox2Values(
                text: 'Athletes',
                value: widget._athletes.length
            )
          ],
        ),
        spacer16,
        SizedBox(
          height: 48,
          child: SearchBar(
              hintText: 'Search',
              trailing: [
                IconButton(
                    onPressed: () async {

                    },
                    icon: const Icon(FeatherIcons.search),
                ),
              ]
          ),
        ),
        spacer16,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SdengPrimaryButton.icon(
                  text: 'Add Team',
                  icon: FeatherIcons.plus,
                  onPressed: () {
                    Navigator.of(context).push(AddTeamPage.route());
                  }
              ),
            ),
            spacer16,
            Expanded(
              child: SdengPrimaryButton.icon(
                  text: 'Add Athlete',
                  icon: FeatherIcons.plus,
                  onPressed: () {
                    Navigator.of(context).push(AddAthletePage.route());
                  }
              ),
            )
          ],
        ),
        ExpansionPanelList(
          children: widget._teams.map(
              (team) {
                final filteredAthletes = widget._athletes
                  .where((athlete) => athlete.teamId == team.id)
                  .toList();
                return ExpansionPanel(
                  headerBuilder: (context, isOpen) => Text(team.name),
                  body: ListView.builder(
                    itemCount: filteredAthletes.length, // Specify itemCount for efficiency
                    itemBuilder: (context, index) {
                      final athlete = filteredAthletes[index];
                      return ListTile(
                        title: Text(athlete.fullName),
                      );
                    },
                  ),
                );
              }).toList(),
        )
      ],
    );
  }

  @override
  void initState() {
    _searchController.addListener(_updateUI);
    super.initState();
  }

  @override
  void dispose() {
    _searchController..removeListener(_updateUI)..dispose();
    super.dispose();
  }

  void _updateUI() {
    setState(() {
      // Do Nothing
    });
  }
}