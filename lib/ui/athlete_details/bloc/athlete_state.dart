part of 'athlete_bloc.dart';

enum PageStatus {
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

class AthleteState {
  AthleteState({
    required this.athlete,
    this.parent,
    this.payment,
    this.pageStatus = PageStatus.loading,
    this.uploadStatus = UploadStatus.none,
    this.medLink = '',
    this.modIscrLink = '',
    this.tessFIPLink = '',
    this.otherFilesMap = const {},
  });

  Athlete athlete;
  Parent? parent;
  Payment? payment;
  String medLink;
  String modIscrLink;
  String tessFIPLink;
  Map<String, String> otherFilesMap;
  PageStatus pageStatus;
  UploadStatus uploadStatus;

  AthleteState copyWith({
    Athlete? athlete,
    Parent? parent,
    Payment? payment,
    PageStatus? pageStatus,
    UploadStatus? uploadStatus,
    String? medLink,
    String? modIscrLink,
    String? tessFIPLink,
    Map<String, String>? otherFilesMap,
  }) {
    return AthleteState(
      athlete: athlete ?? this.athlete,
      parent: parent ?? this.parent,
      payment: payment ?? this.payment,
      pageStatus: pageStatus ?? this.pageStatus,
      medLink: medLink ?? this.medLink,
      modIscrLink: modIscrLink ?? this.modIscrLink,
      tessFIPLink: tessFIPLink ?? this.tessFIPLink,
      otherFilesMap: otherFilesMap ?? this.otherFilesMap,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}