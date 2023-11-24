part of 'payments_bloc.dart';

enum PaymentsStatus {
  loading,
  loaded,
  failure
}

class PaymentsState {
  PaymentsState({
    this.athleteList = const [],
    this.paymentList = const [],
    this.notPayList = const [],
    this.partialList = const [],
    this.okList = const [],
    this.paymentsStatus = PaymentsStatus.loading,
  });

  final List<Athlete> athleteList;
  final List<Payment> paymentList;
  final List<Athlete> notPayList;
  final List<Athlete> okList;
  final List<Athlete> partialList;
  final PaymentsStatus paymentsStatus;

  PaymentsState copyWith({
    List<Athlete>? athleteList,
    List<Payment>? paymentList,
    List<Athlete>? notPayList,
    List<Athlete>? okList,
    List<Athlete>? partialList,
    PaymentsStatus? paymentsStatus,
  }) {
    return PaymentsState(
      athleteList: athleteList ?? this.athleteList,
      paymentList: paymentList ?? this.paymentList,
      notPayList: notPayList ?? this.notPayList,
      partialList: partialList ?? this.partialList,
      okList: okList ?? this.okList,
      paymentsStatus: paymentsStatus ?? this.paymentsStatus,
    );
  }
}