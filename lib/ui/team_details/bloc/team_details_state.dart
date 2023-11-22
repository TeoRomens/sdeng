part of 'team_details_bloc.dart';

enum TeamDetailsPageStatus {
  loading,
  loaded,
  failure
}

class TeamDetailsState {
  TeamDetailsState({
    this.search = '',
    this.athletesList = const [],
    this.earnings = 0,
    this.cashLeft = 0,
    this.pageStatus= TeamDetailsPageStatus.loading,
    this.selectedAthlete,
  });

  final String search;
  List<Athlete> athletesList = [];
  final int earnings;
  final int cashLeft;
  final TeamDetailsPageStatus pageStatus;
  final Athlete? selectedAthlete;

  TeamDetailsState copyWith({
    String? search,
    List<Athlete>? athletesList,
    TeamDetailsPageStatus? pageStatus,
    int? earnings,
    int? cashLeft,
    Athlete? selectedAthlete,
  }) {
    return TeamDetailsState(
      search: search ?? this.search,
      athletesList: athletesList ?? this.athletesList,
      pageStatus: pageStatus ?? this.pageStatus,
      earnings: earnings ?? this.earnings,
      cashLeft: cashLeft ?? this.cashLeft,
      selectedAthlete: selectedAthlete ?? this.selectedAthlete,
    );
  }
}