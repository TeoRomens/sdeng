part of 'med_expires_bloc.dart';

enum Status {
  loading,
  loaded,
  failure
}

enum UploadStatus {
  none,
  uploading,
  success,
  failure
}

class MedExpiresState {
  MedExpiresState({
    this.team,
    this.athletesList = const [],
    this.expiresDateList = const [],
    this.status= Status.loading,
    this.uploadStatus = UploadStatus.none,
  });

  Team? team;
  List<Athlete> athletesList;
  List<DateTime> expiresDateList;
  Status status;
  UploadStatus uploadStatus;

  MedExpiresState copyWith({
    Team? team,
    List<Athlete>? athletesList,
    List<DateTime>? expiresDateList,
    Status? status,
    UploadStatus? uploadStatus,
  }) {
    return MedExpiresState(
      team: team ?? this.team,
      athletesList: athletesList ?? this.athletesList,
      expiresDateList: expiresDateList ?? this.expiresDateList,
      status: status ?? this.status,
      uploadStatus: uploadStatus ?? this.uploadStatus
    );
  }
}