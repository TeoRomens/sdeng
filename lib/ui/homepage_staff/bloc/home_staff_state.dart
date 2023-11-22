part of 'home_staff_bloc.dart';

enum HomeStatus {
  loading,
  loaded,
  failure
}

class HomeStaffState {
  HomeStaffState({
    this.teamsList = const [],
    this.homeStatus = HomeStatus.loading,
  });

  List<Team> teamsList = [];
  final HomeStatus homeStatus;

  HomeStaffState copyWith({
    List<Team>? teamsList,
    HomeStatus? homeStatus,
  }) {
    return HomeStaffState(
      teamsList: teamsList ?? this.teamsList,
      homeStatus: homeStatus ?? this.homeStatus,
    );
  }
}