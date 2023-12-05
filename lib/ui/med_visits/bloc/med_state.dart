part of 'med_bloc.dart';

enum MedStatus {
  loading,
  loaded,
  failure
}

class MedState {
  MedState({
    this.expiredList = const [],
    this.nearExpiredList = const [],
    this.unknownList = const [],
    this.medStatus = MedStatus.loading,
  });

  final List<Athlete> expiredList;
  final List<Athlete> nearExpiredList;
  final List<Athlete> unknownList;
  final MedStatus medStatus;

  MedState copyWith({
    List<Athlete>? expiredList,
    List<Athlete>? nearExpiredList,
    List<Athlete>? unknownList,
    MedStatus? medStatus,
  }) {
    return MedState(
      expiredList: expiredList ?? this.expiredList,
      nearExpiredList: nearExpiredList ?? this.nearExpiredList,
      unknownList: unknownList ?? this.unknownList,
      medStatus: medStatus ?? this.medStatus,
    );
  }
}