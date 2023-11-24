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
    this.payments = const [],
    this.banner = '',
    this.pageStatus = PageStatus.loading,
    this.uploadStatus = UploadStatus.none,
    this.medLink = '',
    this.modIscrLink = '',
    this.tessFIPLink = '',
    this.otherFilesMap = const {},
  });

  Athlete athlete;
  Parent? parent;
  List<Payment> payments;
  String medLink;
  String modIscrLink;
  String tessFIPLink;
  String banner;
  Map<String, String> otherFilesMap;
  PageStatus pageStatus;
  UploadStatus uploadStatus;

  AthleteState copyWith({
    Athlete? athlete,
    Parent? parent,
    List<Payment>? payments,
    String? banner,
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
      payments: payments ?? this.payments,
      banner: banner ?? this.banner,
      pageStatus: pageStatus ?? this.pageStatus,
      medLink: medLink ?? this.medLink,
      modIscrLink: modIscrLink ?? this.modIscrLink,
      tessFIPLink: tessFIPLink ?? this.tessFIPLink,
      otherFilesMap: otherFilesMap ?? this.otherFilesMap,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}