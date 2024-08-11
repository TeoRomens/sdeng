part of 'athlete_cubit.dart';

enum AthleteStatus {
  initial,
  loading,
  loaded,
  failure,
}

class AthleteState extends Equatable {
  const AthleteState({
    required this.status,
    required this.athleteId,
    this.athlete,
    this.parent,
    this.medical,
    this.payments = const [],
    this.documents = const [],
    this.paymentFormula,
    this.error = '',
  });

  const AthleteState.initial({required String athleteId, Athlete? athlete})
      : this(
            status: AthleteStatus.initial,
            athleteId: athleteId,
            athlete: athlete);

  final AthleteStatus status;
  final String athleteId;
  final Athlete? athlete;
  final Parent? parent;
  final Medical? medical;
  final List<Payment> payments;
  final List<Document> documents;
  final PaymentFormula? paymentFormula;
  final String error;

  @override
  List<Object?> get props => [
        status,
        athlete,
        parent,
        medical,
        payments,
        documents,
        error,
      ];

  AthleteState copyWith({
    String? athleteId,
    AthleteStatus? status,
    Athlete? athlete,
    Parent? parent,
    Medical? medical,
    List<Payment>? payments,
    List<Document>? documents,
    PaymentFormula? paymentFormula,
    String? error,
  }) {
    return AthleteState(
      status: status ?? this.status,
      athleteId: athleteId ?? this.athleteId,
      athlete: athlete ?? this.athlete,
      parent: parent ?? this.parent,
      medical: medical ?? this.medical,
      payments: payments ?? this.payments,
      documents: documents ?? this.documents,
      paymentFormula: paymentFormula ?? this.paymentFormula,
      error: error ?? this.error,
    );
  }
}
