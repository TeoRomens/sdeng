part of 'events_bloc.dart';

enum MedExamStatus {
  loading,
  loaded,
  failure
}

enum PaymentsStatus {
  loading,
  loaded,
  failure
}

class EventsState {
  EventsState({
    this.teamsList = const [],
    this.medExamExpiredMap = const {},
    this.medExamNearExpireMap = const {},
    this.paymentExpiredList = const [],
    this.medExamStatus = MedExamStatus.loading,
    this.paymentsStatus = PaymentsStatus.loading,
    this.totalAthletes = 0,
    this.numPrimaRataPaid = 0,
    this.numSecRataPaid = 0,
    this.numRataUnPaid = 0,
    this.cashed = 0,
    this.cashLeft = 0,
  });

  final List<Team> teamsList;
  final MedExamStatus medExamStatus;
  final PaymentsStatus paymentsStatus;
  Map<String, int> medExamExpiredMap;
  Map<String, int> medExamNearExpireMap;
  List<Payment> paymentExpiredList;
  final int totalAthletes;
  final int numPrimaRataPaid;
  final int numSecRataPaid;
  final int numRataUnPaid;
  final int cashed;
  final int cashLeft;

  EventsState copyWith({
    List<Team>? teamsList,
    Map<String, int>? medExamExpiredMap,
    Map<String, int>? medExamNearExpireMap,
    List<Payment>? paymentExpiredList,
    MedExamStatus? medExamStatus,
    PaymentsStatus? paymentsStatus,
    int? totalAthletes,
    int? numPrimaRataPaid,
    int? numSecRataPaid,
    int? numRataUnPaid,
    int? cashed,
    int? cashLeft,
  }) {
    return EventsState(
      teamsList: teamsList ?? this.teamsList,
      medExamExpiredMap: medExamExpiredMap ?? this.medExamExpiredMap,
      medExamNearExpireMap: medExamNearExpireMap ?? this.medExamNearExpireMap,
      paymentExpiredList: paymentExpiredList ?? this.paymentExpiredList,
      medExamStatus: medExamStatus ?? this.medExamStatus,
      paymentsStatus: paymentsStatus ?? this.paymentsStatus,
      totalAthletes: totalAthletes ?? this.totalAthletes,
      numPrimaRataPaid: numPrimaRataPaid ?? this.numPrimaRataPaid,
      numSecRataPaid: numSecRataPaid ?? this.numSecRataPaid,
      numRataUnPaid: numRataUnPaid ?? this.numRataUnPaid,
      cashLeft: cashLeft ?? this.cashLeft,
      cashed: cashed ?? this.cashed,
    );
  }
}