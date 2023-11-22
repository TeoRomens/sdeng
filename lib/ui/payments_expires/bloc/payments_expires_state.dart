part of 'payments_expires_bloc.dart';

enum Status {
  loading,
  loaded,
  failure
}

class PayExpiresState {
  PayExpiresState({
    this.athletesList = const [],
    this.paymentsList = const [],
    this.status= Status.loading,
  });

  List<Athlete> athletesList;
  List<Payment> paymentsList;
  Status status;

  PayExpiresState copyWith({
    List<Athlete>? athletesList,
    List<Payment>? paymentsList,
    Status? status,
  }) {
    return PayExpiresState(
      athletesList: athletesList ?? this.athletesList,
      paymentsList: paymentsList ?? this.paymentsList,
      status: status ?? this.status,
    );
  }
}