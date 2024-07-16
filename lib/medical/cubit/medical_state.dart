part of 'medical_cubit.dart';

enum MedicalStatus {
  initial,
  loading,
  populated,
  failure,
}

class MedicalState extends Equatable {
  const MedicalState({
    required this.status,
    this.expiredMedicals = const [],
    this.expiringMedicals = const [],
    this.goodMedicals = const [],
    this.unknownMedicals = const [],
  });

  const MedicalState.initial() : this(
    status: MedicalStatus.initial,
  );

  final MedicalStatus status;
  final List<Medical> expiredMedicals;
  final List<Medical> expiringMedicals;
  final List<Medical> goodMedicals;
  final List<Medical> unknownMedicals;

  @override
  List<Object> get props => [
    status,
    expiredMedicals,
    expiringMedicals,
    goodMedicals,
    unknownMedicals,
  ];

  MedicalState copyWith({
    MedicalStatus? status,
    List<Medical>? expiredMedicals,
    List<Medical>? expiringMedicals,
    List<Medical>? goodMedicals,
    List<Medical>? unknownMedicals,
  }) {
    return MedicalState(
      status: status ?? this.status,
      expiredMedicals: expiredMedicals ?? this.expiredMedicals,
      expiringMedicals: expiringMedicals ?? this.expiringMedicals,
      goodMedicals: goodMedicals ?? this.goodMedicals,
      unknownMedicals: unknownMedicals ?? this.unknownMedicals,
    );
  }
}
